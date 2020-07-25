Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD57722D797
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 14:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgGYMyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 08:54:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:33912 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726618AbgGYMye (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jul 2020 08:54:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 93B88ACA7;
        Sat, 25 Jul 2020 12:54:42 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 82B0C604C9; Sat, 25 Jul 2020 14:54:33 +0200 (CEST)
Date:   Sat, 25 Jul 2020 14:54:33 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: ethtool 5.7: --change commands fail
Message-ID: <20200725125433.igpkdwd26dxesxno@lion.mk-sys.cz>
References: <20200725064936.GB125759@manjaro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200725064936.GB125759@manjaro>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 25, 2020 at 09:49:36AM +0300, Ali MJ Al-Nasrawy wrote:
> ethtool: v5.7
> kernel: v5.4.52
> driver: r8169 + libphy
> 
> Starting from v5.7, all ethtool --change commands fail to apply and
> show the following error message:
> 
> $ ethtool -s ens5 autoneg off
> netlink error: No such file or directory
> Cannot set new settings: No such file or directory
>   not setting autoneg
> 
> 'git bisect' points to:
> 8bb9a04 (ethtool.c: Report transceiver correctly)
> 
> After debugging I found that this commit sets deprecated.transceiver
> and then do_ioctl_slinksettings() checks for it and returns -1.
> errno is thus invalid and the the error message is bogus.
> 
> With debugging enabled:
> 
> $ ethtool --debug 0xffff -s ens5 autoneg off
> sending genetlink packet (32 bytes):
>     msg length 32 genl-ctrl
>     CTRL_CMD_GETFAMILY
>         CTRL_ATTR_FAMILY_NAME = "ethtool"
> <message dump/>
> received genetlink packet (52 bytes):
>     msg length 52 error errno=-2
> <message dump/>
> netlink error: No such file or directory
> offending message:
>     ETHTOOL_MSG_LINKINFO_SET
>         ETHTOOL_A_LINKINFO_PORT = 101
> Cannot set new settings: No such file or directory
>   not setting autoneg

Kernel 5.4.x does not support ethtool netlink so that we fall back to
ioctl. While we want to report transceiver in "ethtool <dev>" output, we
must not pass the value retrieved from kernel back to kernel when
"ethtool -s <dev> ..." command is executed.

Does the patch below help in your setup?

Michal


diff --git a/ethtool.c b/ethtool.c
index d37c223dcc04..1b99ac91dcbf 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -2906,6 +2906,8 @@ static int do_sset(struct cmd_context *ctx)
 		struct ethtool_link_usettings *link_usettings;
 
 		link_usettings = do_ioctl_glinksettings(ctx);
+		memset(&link_usettings->deprecated, 0,
+		       sizeof(link_usettings->deprecated));
 		if (link_usettings == NULL)
 			link_usettings = do_ioctl_gset(ctx);
 		if (link_usettings == NULL) {

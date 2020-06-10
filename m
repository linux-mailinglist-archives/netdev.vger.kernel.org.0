Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B3B1F50FB
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 11:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgFJJNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 05:13:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:51668 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726948AbgFJJNa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jun 2020 05:13:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AAE71AAC6;
        Wed, 10 Jun 2020 09:13:32 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 9316360739; Wed, 10 Jun 2020 11:13:28 +0200 (CEST)
Date:   Wed, 10 Jun 2020 11:13:28 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: ethtool 5.7: netlink ENOENT error when setting WOL
Message-ID: <20200610091328.evddgipbedykwaq6@lion.mk-sys.cz>
References: <77652728-722e-4d3b-6737-337bf4b391b7@gmail.com>
 <6359d5f8-50e4-a504-ba26-c3b6867f3deb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6359d5f8-50e4-a504-ba26-c3b6867f3deb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 10, 2020 at 10:52:26AM +0200, Heiner Kallweit wrote:
> On 10.06.2020 10:26, Heiner Kallweit wrote:
> > Since ethtool 5.7 following happens (kernel is latest linux-next):
> > 
> > ethtool -s enp3s0 wol g
> > netlink error: No such file or directory
> > 
> > With ethtool 5.6 this doesn't happen. I also checked the latest ethtool
> > git version (5.7 + some fixes), error still occurs.
> > 
> > Heiner
> > 
> Bisecting points to:
> netlink: show netlink error even without extack

Just to make sure you are hitting the same problem I'm just looking at,
please check if

- your kernel is built with ETHTOOL_NETLINK=n
- the command actually succeeds (i.e. changes the WoL modes)
- output with of "ethtool --debug 0x12 -s enp3s0 wol g" looks like

  sending genetlink packet (32 bytes):
      msg length 32 genl-ctrl
      CTRL_CMD_GETFAMILY
          CTRL_ATTR_FAMILY_NAME = "ethtool"
  received genetlink packet (52 bytes):
      msg length 52 error errno=-2
  netlink error: No such file or directory
  offending message:
      ETHTOOL_MSG_LINKINFO_SET
          ETHTOOL_A_LINKINFO_PORT = 101

If this is the case, than the commit found by bisect only revealed an
issue which was introduced earlier by commit 76bdf9372824 ("netlink: use
pretty printing for ethtool netlink messages"). The patch below should
suppress the message as intended.

Michal

diff --git a/netlink/nlsock.c b/netlink/nlsock.c
index 2c760b770ec5..c3f09b6ee9ab 100644
--- a/netlink/nlsock.c
+++ b/netlink/nlsock.c
@@ -255,12 +255,12 @@ int nlsock_process_reply(struct nl_socket *nlsk, mnl_cb_t reply_cb, void *data)
 
 		nlhdr = (struct nlmsghdr *)buff;
 		if (nlhdr->nlmsg_type == NLMSG_ERROR) {
-			bool silent = nlsk->nlctx->suppress_nlerr;
+			unsigned int suppress = nlsk->nlctx->suppress_nlerr;
 			bool pretty;
 
 			pretty = debug_on(nlsk->nlctx->ctx->debug,
 					  DEBUG_NL_PRETTY_MSG);
-			return nlsock_process_ack(nlhdr, len, silent, pretty);
+			return nlsock_process_ack(nlhdr, len, suppress, pretty);
 		}
 
 		msgbuff->nlhdr = nlhdr;

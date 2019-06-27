Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECB9858A2E
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 20:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbfF0StJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 14:49:09 -0400
Received: from mail.us.es ([193.147.175.20]:46988 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726443AbfF0StJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 14:49:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 61F0AEA46E
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 20:49:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 50DE3DA732
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 20:49:07 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2FCC391E1; Thu, 27 Jun 2019 20:49:07 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 12F28DA7B6;
        Thu, 27 Jun 2019 20:49:04 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 27 Jun 2019 20:49:04 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id DE7B54265A31;
        Thu, 27 Jun 2019 20:49:03 +0200 (CEST)
Date:   Thu, 27 Jun 2019 20:49:03 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     zhe.he@windriver.com
Cc:     kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: Fix remainder of pseudo-header protocol 0
Message-ID: <20190627184903.atdcwk4wnfaayyer@salvia>
References: <1561346258-272481-1-git-send-email-zhe.he@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1561346258-272481-1-git-send-email-zhe.he@windriver.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 11:17:38AM +0800, zhe.he@windriver.com wrote:
> From: He Zhe <zhe.he@windriver.com>
> 
> Since v5.1-rc1, some types of packets do not get unreachable reply with the
> following iptables setting. Fox example,
> 
> $ iptables -A INPUT -p icmp --icmp-type 8 -j REJECT
> $ ping 127.0.0.1 -c 1
> PING 127.0.0.1 (127.0.0.1) 56(84) bytes of data.
> — 127.0.0.1 ping statistics —
> 1 packets transmitted, 0 received, 100% packet loss, time 0ms
> 
> We should have got the following reply from command line, but we did not.
> From 127.0.0.1 icmp_seq=1 Destination Port Unreachable
> 
> Yi Zhao reported it and narrowed it down to:
> 7fc38225363d ("netfilter: reject: skip csum verification for protocols that don't support it"),
> 
> This is because nf_ip_checksum still expects pseudo-header protocol type 0 for
> packets that are of neither TCP or UDP, and thus ICMP packets are mistakenly
> treated as TCP/UDP.
> 
> This patch corrects the conditions in nf_ip_checksum and all other places that
> still call it with protocol 0.

Looking at 7fc38225363dd8f19e667ad7c77b63bc4a5c065d, I wonder this can
be fixed while simplifying it...

I think nf_reject_verify_csum() is useless?

In your patch, now you explicitly check for IPPROTO_TCP and
IPPROTO_UDP to validate the checksum.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 566071B2B08
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 17:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726848AbgDUPU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 11:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726732AbgDUPUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 11:20:25 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A749C061A10;
        Tue, 21 Apr 2020 08:20:25 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jQuhC-00DWGd-L2; Tue, 21 Apr 2020 17:20:22 +0200
Message-ID: <a8b99311d732d2627d57beb3970fab9cdcd0e4d2.camel@sipsolutions.net>
Subject: how to use skb_postpush_rcsum()?
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Date:   Tue, 21 Apr 2020 17:20:18 +0200
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This is probably a stupid question but I'm hitting my head against the
wall ...

I have an skb. I have this:


        if (skb->ip_summed == CHECKSUM_COMPLETE) {
                printk(KERN_DEBUG "csum before\n");
                printk(KERN_DEBUG "  hw = 0x%.4x\n", skb->csum);
                printk(KERN_DEBUG "  sw = 0x%.4x\n", csum_fold(skb_checksum(skb, 0, skb->len, 0)));
        }

	ehdr = skb_push(skb, ETH_HLEN);
	memcpy(ehdr, &tmp, ETH_HLEN);
	skb_postpush_rcsum(skb, &tmp, ETH_HLEN);

        if (skb->ip_summed == CHECKSUM_COMPLETE) {
                printk(KERN_DEBUG "csum after\n");
                printk(KERN_DEBUG "  hw = 0x%.4x\n", csum_fold(skb->csum));
                printk(KERN_DEBUG "  sw = 0x%.4x\n", csum_fold(skb_checksum(skb, 0, skb->len, 0)));
        }

Why does this print, for example:

csum before
  hw = 0xce81
  sw = 0xce81
csum after
  hw = 0x5f36
  sw = 0xfc39


I'm clearly doing something wrong, but most of the examples seem to do
things this way, so what I'm I doing wrong?

johannes


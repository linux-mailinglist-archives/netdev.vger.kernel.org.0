Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 601F0386BA9
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 22:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237059AbhEQUtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 16:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbhEQUtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 16:49:53 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F46C061573;
        Mon, 17 May 2021 13:48:36 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1621284514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=N9j0B7b156ySsfMwDJsNRd7Lot/GWP1durNGX4F30bE=;
        b=1ZpNYLsTCuxDd2w4It1l3dHPjwwAqXAEgSY+DEPNfEPoHcR+Tj8HSX/lM6OuPLk7dDZQVW
        W1mANCzHmyx/moYnbSqJIsfksQzHubt7JiZM2zKDIcbWHzozO2ubMZ64DlHO+vvi6SI3/u
        kzgUMF1r1LiMVSf6GAg4a80TbFVuMBAThFvwPAqShd0TKE41wvAv3ecwduS+Wu1jdbDg0I
        AbAfl/Kx/MAGDQmSaMwvUS+//Ee8ZAgjroZ+SaUJfqQ5dTIfSI6X60+ohc6ZLvj7Z1TR8t
        CqFlk/za3NV3QACI21PFNIS7CqVMAmhb4Di/XCXQ8oCYUumaEBmQw4P267xG8Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1621284514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=N9j0B7b156ySsfMwDJsNRd7Lot/GWP1durNGX4F30bE=;
        b=Cq5gGnOum9YEtmqRoidToVZ0cJKjg3O1ZDCn247dy6VTZmmSgwiY8J34jS0r/5mY/3Ru7v
        WBWf4Bc9muZaDeDA==
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, jbrandeb@kernel.org,
        "frederic\@kernel.org" <frederic@kernel.org>,
        "juri.lelli\@redhat.com" <juri.lelli@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, abelits@marvell.com,
        "linux-api\@vger.kernel.org" <linux-api@vger.kernel.org>,
        "bhelgaas\@google.com" <bhelgaas@google.com>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "rostedt\@goodmis.org" <rostedt@goodmis.org>,
        "peterz\@infradead.org" <peterz@infradead.org>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,
        "sfr\@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "stephen\@networkplumber.org" <stephen@networkplumber.org>,
        "rppt\@linux.vnet.ibm.com" <rppt@linux.vnet.ibm.com>,
        "jinyuqi\@huawei.com" <jinyuqi@huawei.com>,
        "zhangshaokun\@hisilicon.com" <zhangshaokun@hisilicon.com>,
        netdev@vger.kernel.org, chris.friesen@windriver.com,
        Nitesh Lal <nilal@redhat.com>, Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH tip:irq/core v1] genirq: remove auto-set of the mask when setting the hint
In-Reply-To: <20210504092340.00006c61@intel.com>
Date:   Mon, 17 May 2021 22:48:33 +0200
Message-ID: <87pmxpdr32.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 04 2021 at 09:23, Jesse Brandeburg wrote:
> I'd add in addition that irqbalance daemon *stopped* paying attention
> to hints quite a while ago, so I'm not quite sure what purpose they
> serve.

The hint was added so that userspace has a better understanding where it
should place the interrupt. So if irqbalanced ignores it anyway, then
what's the point of the hint? IOW, why is it still used drivers?

Now there is another aspect to that. What happens if irqbalanced does
not run at all and a driver relies on the side effect of the hint
setting the initial affinity. Bah...

While none of the drivers (except the perf muck) actually prevents
userspace from fiddling with the affinity (via IRQF_NOBALANCING) a
deeper inspection shows that they actually might rely on the current
behaviour if irqbalanced is disabled. Of course every driver has its own
convoluted way to do that and all of those functions are well
documented. What a mess.

If the hint still serves a purpose then we can provide a variant which
solely applies the hint and does not fiddle with the actual affinity,
but if the hint is useless anyway then we have a way better option to
clean that up.

Most users are in networking, there are a few in crypto, a couple of
leftovers in scsi, virtio and a handfull of oddball drivers.

The perf muck wants to be cleaned up anyway as it's just crystal clear
abuse.

Thanks,

        tglx

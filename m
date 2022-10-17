Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 166ED6015A7
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 19:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbiJQRru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 13:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiJQRrt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 13:47:49 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046C772FF9;
        Mon, 17 Oct 2022 10:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7HD+WISAn1duZ9U9CGqXm432EWn4Ma5R+xZU2Bhk5sk=; b=taNL36Ummo0fRuDU40elkzvryu
        3aPNushaDLUo/mUNgRYTRXqtSj1QyJDNSjxcdpseLpZe64JFXWIu7WFJNJDC28QakcJffQKeP1NNw
        gbwzkC2RH3RkHNiYWMR4cyVq0glukc5sNqpyGcL/ONbmVBgMz5r6DEoeS5N8pT6rTNa/gNpvfTXyk
        BSgs+J9T2g4ChaeBUu5C68KSx7XCFOf8XUKgTwyku8t2iRCABn0G1A8R5380vQ5V7kpom/5YKaC3R
        NbIV8pMUfBkV61voMA+DcuiOqcqrSa36BCzwn0xczkg2/h47Y1UuaI0bovxWQnrWWXjTeGBnEyQdG
        OMq7+d9A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34756)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1okUCs-0003Xo-JT; Mon, 17 Oct 2022 18:47:18 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1okUCg-0000HR-Mf; Mon, 17 Oct 2022 18:47:06 +0100
Date:   Mon, 17 Oct 2022 18:47:06 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        Marc Zyngier <maz@kernel.org>, will@kernel.org,
        Mark Rutland <mark.rutland@arm.com>, arnd@arndb.de,
        Catalin Marinas <catalin.marinas@arm.com>,
        kexec@lists.infradead.org, pmladek@suse.com, bhe@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        x86@kernel.org, kernel-dev@igalia.com, kernel@gpiccoli.net,
        halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com, andriy.shevchenko@linux.intel.com,
        bp@alien8.de, corbet@lwn.net, d.hatayama@jp.fujitsu.com,
        dave.hansen@linux.intel.com, dyoung@redhat.com,
        feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        xuqiang36@huawei.com
Subject: Re: [PATCH V3 01/11] ARM: Disable FIQs (but not IRQs) on CPUs
 shutdown paths
Message-ID: <Y02VGh+eDLMyi/Aj@shell.armlinux.org.uk>
References: <20220819221731.480795-1-gpiccoli@igalia.com>
 <20220819221731.480795-2-gpiccoli@igalia.com>
 <a25cb242-7c85-867c-8a61-f3119458dcdb@igalia.com>
 <8e30b99e-70ed-7d5a-ea1f-3b0fadb644bc@igalia.com>
 <Y01j/3qKUvj346AH@shell.armlinux.org.uk>
 <aea7dad7-987d-43ad-3abc-815ede97a127@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aea7dad7-987d-43ad-3abc-815ede97a127@igalia.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 17, 2022 at 11:50:05AM -0300, Guilherme G. Piccoli wrote:
> On 17/10/2022 11:17, Russell King (Oracle) wrote:
> > [...]
> >> Monthly ping - let me know if there's something I should improve in
> >> order this fix is considered!
> > 
> > Patches don't get applied unless they end up in the patch system.
> > Thanks.
> > 
> 
> Thanks Russell! Can you show me some documentation on how should I send
> the patches to this patch system? My understanding based in the
> MAINTAINERS file is that we should send the arm32 patches to you + arm ML.

Look below in my signature --.
                             |
			     v
-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

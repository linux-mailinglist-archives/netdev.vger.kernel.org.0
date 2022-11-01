Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A80E61447C
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 07:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiKAGGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 02:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiKAGGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 02:06:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D7F14090
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 23:06:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A603CB81BD1
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 06:06:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D0DC433D6;
        Tue,  1 Nov 2022 06:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667282809;
        bh=uBwxeF8Fn+8623x/GONofwyeGYHuTFVBYS/zrnEHTXQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K4aui8k96awuMhCQSbmCQXyCuVeuvsiEVXwhpHFQgs8D/PgCMXlxwwo4Gt+v9mDzs
         jPgulA3lgEW7SiEaoSgiCBw9TnMt1OvW4Oh2oDVizg6dm5rdsjziHiWzwUtv8UPZ3A
         J61REN9Lz5CBzjKTDvTTttEygMt1bFOzabU4NtJWpTfXtJsf4/gJu1VAIze+l38D/2
         oSmbOV8U7WPILLEx29b+P01laFAum0YgbwpzkIx8fei/76Zt9b1SvGcBiwfBp5roIj
         jFowhYMXk4fZl5p7jNLaGq5luvNeaKHedQtqKh+cLNBpuGAlxMQUWN5NOIGF3w9huZ
         TZb3/Jfev3bOQ==
Date:   Tue, 1 Nov 2022 08:06:44 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     bongsu.jeon@samsung.com, krzysztof.kozlowski@linaro.org,
        netdev@vger.kernel.org, syzkaller@googlegroups.com
Subject: Re: [PATCH] nfc: Allow to create multiple virtual nci devices
Message-ID: <Y2C3dAk2B5B681Wq@unreal>
References: <20221030142919.3196780-1-dvyukov@google.com>
 <Y1+UHKsFbg46UEvM@unreal>
 <CACT4Y+Y=W2xazqDmrSFDS5ocbsc+H-ZAiHTD1era=dFR4V0gOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+Y=W2xazqDmrSFDS5ocbsc+H-ZAiHTD1era=dFR4V0gOA@mail.gmail.com>
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 31, 2022 at 08:36:57AM -0700, Dmitry Vyukov wrote:
> On Mon, 31 Oct 2022 at 02:23, Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Sun, Oct 30, 2022 at 03:29:19PM +0100, Dmitry Vyukov wrote:
> > > The current virtual nci driver is great for testing and fuzzing.
> > > But it allows to create at most one "global" device which does not allow
> > > to run parallel tests and harms fuzzing isolation and reproducibility.
> > > Restructure the driver to allow creation of multiple independent devices.
> > > This should be backwards compatible for existing tests.
> > >
> > > Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
> > > Cc: Bongsu Jeon <bongsu.jeon@samsung.com>
> > > Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> > > Cc: netdev@vger.kernel.org
> > > ---
> > >  drivers/nfc/virtual_ncidev.c | 143 ++++++++++++++++-------------------
> > >  1 file changed, 66 insertions(+), 77 deletions(-)
> >
> > <...>
> >
> > >  static int virtual_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
> > >  {
> > > -     mutex_lock(&nci_mutex);
> > > -     if (state != virtual_ncidev_enabled) {
> > > -             mutex_unlock(&nci_mutex);
> > > -             kfree_skb(skb);
> > > -             return 0;
> > > -     }
> > > +     struct virtual_nci_dev *vdev = nci_get_drvdata(ndev);
> > >
> > > -     if (send_buff) {
> > > -             mutex_unlock(&nci_mutex);
> > > +     mutex_lock(&vdev->mtx);
> > > +     if (vdev->send_buff) {
> > > +             mutex_unlock(&vdev->mtx);
> > >               kfree_skb(skb);
> >
> > You probably need to set vdev->send_buff to NULL here.
> 
> Hi Leon,
> 
> Thanks for looking at this.
> 
> Are you sure about setting vdev->send_buff to NULL?
> We already have a "cached" skb in vdev->send_buff, we received a new
> one in 'skb' and freed it.
> I assumed the intention is to keep vdev->send_buff intact.

You are right.

> 
> > >               return -1;
> > >       }
> > > -     send_buff = skb_copy(skb, GFP_KERNEL);
> > > -     mutex_unlock(&nci_mutex);
> > > -     wake_up_interruptible(&wq);
> > > +     vdev->send_buff = skb_copy(skb, GFP_KERNEL);
> >
> > You don't check return value of skb_copy(), it can fail, but
> > this function will return 0 (success). Do you do it deliberately?
> >
> > If yes, please add a comment to the code, as it is not clear.
> 
> Good question. I just kept all of this logic as it is now and only
> removed the global vars.

I know :)

> 
> I guess we need something like this, right?
> 
> vdev->send_buff = skb_copy(skb, GFP_KERNEL);
> if (!vdev->send_buff) {
>     mutex_unlock(&vdev->mtx);
>     return -1;
> }
> 
> Though, it's called only from nci_send_frame() and its return value is
> never checked :)

I would say that the most important part is do not continue after
skb_copy() failure.

Thanks

> 
> $ git grep nci_send_frame
> include/net/nfc/nci_core.h:int nci_send_frame(struct nci_dev *ndev,
> struct sk_buff *skb);
> net/nfc/nci/core.c:int nci_send_frame(struct nci_dev *ndev, struct sk_buff *skb)
> net/nfc/nci/core.c:EXPORT_SYMBOL(nci_send_frame);
> drivers/nfc/nfcmrvl/fw_dnld.c:
> nci_send_frame(priv->ndev, out_skb);
> drivers/nfc/nfcmrvl/fw_dnld.c:          nci_send_frame(priv->ndev, out_skb);
> drivers/nfc/nfcmrvl/fw_dnld.c:
> nci_send_frame(priv->ndev, out_skb);
> net/nfc/nci/core.c:             nci_send_frame(ndev, skb);
> net/nfc/nci/core.c:             nci_send_frame(ndev, skb);
> 
> 
> > Thanks
> >
> > > +     mutex_unlock(&vdev->mtx);
> > > +     wake_up_interruptible(&vdev->wq);
> > >       consume_skb(skb);
> > >
> > >       return 0;

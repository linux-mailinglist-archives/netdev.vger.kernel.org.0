Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEE9A531AC8
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbiEWShA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 14:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243625AbiEWSgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 14:36:50 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27FA544C8
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 11:16:39 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-30026b1124bso247207b3.1
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 11:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0y77E6WwK1zFSJV7Q1vK7zjVQnm88vws8NVPGk4izQo=;
        b=j38cuboYFHyj6WAizMS4iffcahmEGUCY7+CSQoUIcs3HG6FVqv5IfPjZd/OgaEMsyp
         JE6k3aYlAawsAzSB4sXWkzY3vJXXvSO7kEI9JCY4ccBQRQoslIkl34Cc7sm8xE7Ji4wI
         YOkqjO+QFQ4SrswZmBAEZioamfqmQit8LkxYl7W0OsCPZZBcBCcHE51mPrT2Lk1ZD4fK
         +7kmR2xhugUwL3u0i5XSU/SfOV6RJZKdGgEXfb4hwBypYhAFQzctVMWmgwJ9vsAqRPfP
         Xlc44QCb+1DrrEyIUMJa9hFfYNZc/9WNxxDOVGzsruyj3GDVFOilzyVWPuBttoAJ541Q
         /ysw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0y77E6WwK1zFSJV7Q1vK7zjVQnm88vws8NVPGk4izQo=;
        b=DLSd63yQAPALqsD6ReHS9ldux/frYYjqbk8TCVxlOhN6k3P24hqAzeGJNNEiWE/1+9
         AUvoNEh/qFnyqxfS6lbvBSty2Xhd0DJnuFblGt9YlIkRMDRFlJE1Cmdftd95+tKm06At
         Xa6Gm2P8wbNxUi2IorRxYfbztkQhmslvu8f25wS/EwYtb4VEQkmLok4pJxlvz5HcK1+x
         IZO+065ocDllM1YHhWPn9vB8x50H6bKFgd2BWci3rpJaOWyXzbfMUiXjIPpKX4k6hHrC
         jF/gdgY2WaJwRmbhkyJ0iAKPBUPb0TEjmynBdSrg8I2lV/OiQPI0ojC3mwU2LDOn7dlp
         U1UQ==
X-Gm-Message-State: AOAM531GCm1M5rHJJU4Q+xtsh1IXYHgQdMPkr3sAS4TtncKsGK7Bh5NH
        3jwivsOC/1RTQ1h7hdLMDvBUgn+IR/4TtVkFqZy4z1OTiBRJgw==
X-Google-Smtp-Source: ABdhPJxwOAlcTfNEtlCVMp38XgEvK3FOa+mVgPgBP67m/qHx12oQZYR6JnaFSaj35UHSnmK3X4nuTRFYD4+p1MwyeNc=
X-Received: by 2002:a81:1d4e:0:b0:2f7:be8b:502e with SMTP id
 d75-20020a811d4e000000b002f7be8b502emr24820777ywd.278.1653329679222; Mon, 23
 May 2022 11:14:39 -0700 (PDT)
MIME-Version: 1.0
References: <20211202032139.3156411-1-eric.dumazet@gmail.com>
 <20211202032139.3156411-4-eric.dumazet@gmail.com> <20220523110315.6f0637ed@kernel.org>
In-Reply-To: <20220523110315.6f0637ed@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 23 May 2022 11:14:27 -0700
Message-ID: <CANn89iKUV+brdTa0SZYi_pov8hKEL-9nXo-wKQsLP6xtY261UQ@mail.gmail.com>
Subject: Re: [PATCH net-next 03/19] net: add dev_hold_track() and
 dev_put_track() helpers
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 23, 2022 at 11:03 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed,  1 Dec 2021 19:21:23 -0800 Eric Dumazet wrote:
> > +static inline void dev_hold_track(struct net_device *dev,
> > +                               netdevice_tracker *tracker, gfp_t gfp)
> > +{
> > +     if (dev) {
> > +             dev_hold(dev);
> > +#ifdef CONFIG_NET_DEV_REFCNT_TRACKER
> > +             ref_tracker_alloc(&dev->refcnt_tracker, tracker, gfp);
> > +#endif
> > +     }
> > +}
> > +
> > +static inline void dev_put_track(struct net_device *dev,
> > +                              netdevice_tracker *tracker)
> > +{
> > +     if (dev) {
> > +#ifdef CONFIG_NET_DEV_REFCNT_TRACKER
> > +             ref_tracker_free(&dev->refcnt_tracker, tracker);
> > +#endif
> > +             dev_put(dev);
> > +     }
> > +}
>
> Hi Eric, how bad would it be if we renamed dev_hold/put_track() to
> netdev_hold/put()? IIUC we use the dev_ prefix for "historic reasons"
> could this be an opportunity to stop doing that?

Sure, we can do that, thanks.

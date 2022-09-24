Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9564C5E8F8F
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 21:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiIXTvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Sep 2022 15:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiIXTvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Sep 2022 15:51:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 715FE4C638
        for <netdev@vger.kernel.org>; Sat, 24 Sep 2022 12:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664049065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=odn3sqVpyQr9YAIBdJl0sjpnZhEcZ6gddk067fbqm2I=;
        b=jTMJKhNpvaLzeie1RH2+wY/9weTK5W3NEbUVVbQqjGXavf3rzUIRlFFyBEvgQsoVRLHhug
        Fvjjr6na7DwcHb2QV/bSLcLJNqAf5CNCx4fXDBoof/zHQY5U5b17qPjj/tsaudfnG7xVhR
        sb7QMC/SbKGUJHQjna6Lb0HZ41QVcGU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-83-QhREKn1CMMaQeZzxoFJi_w-1; Sat, 24 Sep 2022 15:51:03 -0400
X-MC-Unique: QhREKn1CMMaQeZzxoFJi_w-1
Received: by mail-wr1-f69.google.com with SMTP id d30-20020adfa41e000000b00228c0e80c49so515821wra.21
        for <netdev@vger.kernel.org>; Sat, 24 Sep 2022 12:51:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=odn3sqVpyQr9YAIBdJl0sjpnZhEcZ6gddk067fbqm2I=;
        b=6+VDIj3Z/UuJgx102j+CNI8ka6BoFkMbFlXL7fuUg75WIDkPV+dOlfiHPwT18Q4G85
         TTa77GUi2a52FPjmIXSR3tyB251/nAOnt9iNSbOqxVlfkDl3hwTEs9jSPLvKb8vwRZ9n
         Lqmc0ZHn9UfPDOfpOzmGd06iRhmt5j/Ed+s/qw3GCWuaY4C/MBULjtYRXhuS06/Bw7t8
         44tMFKrw9eJFdtiE0qwHDipy7vndxtsZqiGdc8/53nGwMMXMiBtJn5Dkw6qI7ZxSN0P1
         h1fCzSX+y2gW6Jb6Rs6+Lw1lUuM/QChhqWEiB1s77+foT2PeNOa+QHxtXR55lCyUGwE3
         Wy8g==
X-Gm-Message-State: ACrzQf2WemLQKBnqxh3itpMpKi3jCSSCMCFLOfcBN39mlpwce4tIqNXG
        /SVyKfy/mvKnopRFmka3X/exj9DFl7rKOFUXEvPv7vPQK5igzezBql4pCkADCaySGwHiJ1lnhdP
        p151SaMDLkjVln75q/meQDKqrKjRHxtrQ
X-Received: by 2002:a05:600c:4ec8:b0:3b4:bdc6:9b3d with SMTP id g8-20020a05600c4ec800b003b4bdc69b3dmr16854960wmq.181.1664049062819;
        Sat, 24 Sep 2022 12:51:02 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4eqAWG5MtLx9igHHMXUzF17iBbkbU3nppsljsH2P1nrwxtaai7gZOJqs6vPd9bABGg4AOxbpWbbUa/JDAtCDQ=
X-Received: by 2002:a05:600c:4ec8:b0:3b4:bdc6:9b3d with SMTP id
 g8-20020a05600c4ec800b003b4bdc69b3dmr16854945wmq.181.1664049062601; Sat, 24
 Sep 2022 12:51:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220905203412.1322947-1-miquel.raynal@bootlin.com>
 <20220905203412.1322947-6-miquel.raynal@bootlin.com> <CAK-6q+gH3dRj6szUV6Add7G5nh1-5rBUpVLrrdbkjS22tz3ueA@mail.gmail.com>
 <20220921174932.37f2938f@xps-13>
In-Reply-To: <20220921174932.37f2938f@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sat, 24 Sep 2022 15:50:51 -0400
Message-ID: <CAK-6q+i64s=u-K3-t4So8jtQQxx_+FuWVc_THPxtFw6ruJ-zrg@mail.gmail.com>
Subject: Re: [PATCH wpan/next v3 5/9] net: mac802154: Drop IEEE802154_HW_RX_DROP_BAD_CKSUM
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Sep 21, 2022 at 11:49 AM Miquel Raynal
<miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> aahringo@redhat.com wrote on Thu, 8 Sep 2022 20:49:36 -0400:
>
> > Hi,
> >
> > On Mon, Sep 5, 2022 at 4:34 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > This IEEE802154_HW_RX_DROP_BAD_CKSUM flag was only used by hwsim to
> > > reflect the fact that it would not validate the checksum (FCS). In other
> > > words, the filtering level of hwsim is always "NONE" while the core
> > > expects it to be higher.
> > >
> > > Now that we have access to real filtering levels, we can actually use
> > > them and always enforce the "NONE" level in hwsim. This case is already
> > > correctly handled in the receive so we can drop the flag.
> > >
> >
> > I would say the whole hwsim driver currently only works because we
> > don't transmit wrong frames on a virtual hardware... However this can
> > be improved, yes. In my opinion the hwsim driver should pretend to
> > work like other transceivers sending frames to mac802154. That means
> > the filtering level should be implemented in hwsim not in mac802154 as
> > on real hardware the hardware would do filtering.
> >
> > I think you should assume for now the previous behaviour that hwsim
> > does not send bad frames out. Of course there is a bug but it was
> > already there before, but the fix would be to change hwsim driver.
>
> Well, somehow I already implemented all the filtering by software in
> one of the other patches. I now agree that it was not relevant (because
> of the AACK issue you raised), but instead of fully dropping this code
> I might just move it to hwsim because there it would perfectly make
> sense?
>

Yes, I agree. You should make the "in-driver receive path" acting like
other hardware (In sense what we currently agree on what filtering
they do) if promiscuous mode is turned off/on.

It makes sense and should be done there. The
IEEE802154_HW_RX_DROP_BAD_CKSUM flag should still be dropped.

- Alex


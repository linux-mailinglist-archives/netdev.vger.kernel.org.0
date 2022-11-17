Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEE2162DEE2
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 15:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239305AbiKQO7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 09:59:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238685AbiKQO7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 09:59:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921B8CE0
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 06:58:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668697109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i8w7JapNc2AEan+thMqDHHyLoKCn+2jxYTF198G9HGw=;
        b=T4xeJkCNXLFT4jTIgjc/v2VaCjGHeAHfLtIdgXEL+KgffRa3nSJn9aH9FHbSE0bo7/oQ2w
        HlMsbvjxCgPIZ3bWvZUDYBUCl94+vSo8LbPLC4EXTGpEjKqot4oP5H+cjs9XPfuOgkNlHY
        eRmt1B80Muh18sGXprF8xq234a7/h3c=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-373-QRlbfyl1OJOvlWjRuy53nQ-1; Thu, 17 Nov 2022 09:58:28 -0500
X-MC-Unique: QRlbfyl1OJOvlWjRuy53nQ-1
Received: by mail-qt1-f200.google.com with SMTP id y19-20020a05622a121300b003a526e0ff9bso1831781qtx.15
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 06:58:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i8w7JapNc2AEan+thMqDHHyLoKCn+2jxYTF198G9HGw=;
        b=1fuXiiXuJmlS/Psd7CDZk3poIBV9zUrgHpcBV//6fOMn5pnWEsRVtuvWvTphOwqGqy
         l5jSm92jMRea/UeKKPcSoy3SkgMiYoTKvgdiQFxfwu1H0i3Y7Hea+r2v8/yNpCIZ5TfX
         MoHf5xaRfuT1qpNzM8rpQUMVboirRTsykzUl3mTjguWn8xw7b4q1lkvAhCVVsqfEkc0e
         yiXrO2e4Izq5xlDmAFDqR/2fEIZOjO3nFwGkDmYd1qCuF4m5M6hFmMbF1waGAvjZeHeD
         oPZ3wCd0w6EdN0QH+dhDWZg9JNaUdeWVj5FD1D4tOw2QJBZMgR9jdHWvsIL0gJQlztPg
         LtTA==
X-Gm-Message-State: ANoB5plgksSdd07WtqPZ2dT/Dh6Aj8nRblH7DdedvQ9NWpqG+F+4XkEI
        /s8fvbUnt0QFGDKlMk01XvoP7D08zLxZk62vR5hCrxE+gT8qdIAlRK6miTGZSW3V5Ci4U4w5PB0
        21wI1bqDG/yAPBzcG
X-Received: by 2002:ac8:7444:0:b0:39a:5f99:c7ce with SMTP id h4-20020ac87444000000b0039a5f99c7cemr2494491qtr.621.1668697108068;
        Thu, 17 Nov 2022 06:58:28 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7xT6Ka7Oapxh1M+YmEOMpnff0HylsZuAocyN/RwOie8qB6prKMuGERkHs3Th88CtcjpqLF9w==
X-Received: by 2002:ac8:7444:0:b0:39a:5f99:c7ce with SMTP id h4-20020ac87444000000b0039a5f99c7cemr2494473qtr.621.1668697107799;
        Thu, 17 Nov 2022 06:58:27 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id u7-20020a05620a430700b006eed75805a2sm553033qko.126.2022.11.17.06.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 06:58:27 -0800 (PST)
Message-ID: <040d238e73a155789ff3cf2e6c70bbc27991cb81.camel@redhat.com>
Subject: Re: [PATCH net-next] NFC: nci: Extend virtual NCI deinit test
From:   Paolo Abeni <pabeni@redhat.com>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     bongsu.jeon@samsung.com, krzysztof.kozlowski@linaro.org,
        netdev@vger.kernel.org, syzkaller@googlegroups.com,
        Jakub Kicinski <kuba@kernel.org>
Date:   Thu, 17 Nov 2022 15:58:24 +0100
In-Reply-To: <CACT4Y+aiGFRoBGz6m9SQME98K_awscXpXES3TZPDgR9i7cQL3Q@mail.gmail.com>
References: <20221115095941.787250-1-dvyukov@google.com>
         <e5a89aa3bffe442e7bb5e58af5b5b43d7745995b.camel@redhat.com>
         <CACT4Y+aiGFRoBGz6m9SQME98K_awscXpXES3TZPDgR9i7cQL3Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-11-17 at 14:47 +0100, Dmitry Vyukov wrote:
> On Thu, 17 Nov 2022 at 13:47, Paolo Abeni <pabeni@redhat.com> wrote:
> > 
> > On Tue, 2022-11-15 at 10:59 +0100, Dmitry Vyukov wrote:
> > > Extend the test to check the scenario when NCI core tries to send data
> > > to already closed device to ensure that nothing bad happens.
> > > 
> > > Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
> > > Cc: Bongsu Jeon <bongsu.jeon@samsung.com>
> > > Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> > > Cc: Jakub Kicinski <kuba@kernel.org>
> > > Cc: netdev@vger.kernel.org
> > > ---
> > >  tools/testing/selftests/nci/nci_dev.c | 10 ++++++++++
> > >  1 file changed, 10 insertions(+)
> > > 
> > > diff --git a/tools/testing/selftests/nci/nci_dev.c b/tools/testing/selftests/nci/nci_dev.c
> > > index 162c41e9bcae8..272958a4ad102 100644
> > > --- a/tools/testing/selftests/nci/nci_dev.c
> > > +++ b/tools/testing/selftests/nci/nci_dev.c
> > > @@ -888,6 +888,16 @@ TEST_F(NCI, deinit)
> > >                          &msg);
> > >       ASSERT_EQ(rc, 0);
> > >       EXPECT_EQ(get_dev_enable_state(&msg), 0);
> > > +
> > > +     // Test that operations that normally send packets to the driver
> > > +     // don't cause issues when the device is already closed.
> > > +     // Note: the send of NFC_CMD_DEV_UP itself still succeeds it's just
> > > +     // that the device won't actually be up.
> > > +     close(self->virtual_nci_fd);
> > > +     self->virtual_nci_fd = -1;
> > 
> > I think you need to handle correctly negative value of virtual_nci_fd
> > in FIXTURE_TEARDOWN(NCI), otherwise it should trigger an assert on
> > pthread_join() - read() operation will fail in virtual_deinit*()
> 
> Hi Paolo,
> 
> In this test we also set self->open_state = 0. This will make
> FIXTURE_TEARDOWN(NCI) skip all of the deinit code. It will still do
> close(self->virtual_nci_fd) w/o checking the return value. So it will
> be close(-1), which will return an error, but we won't check it.

Thanks for the pointer. The code looks indeed correct.

And sorry for the late nit picking, but I guess it's better to avoid
the '//' comment marker and use instead the multi-line ones.

Thanks!

Paolo


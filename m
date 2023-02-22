Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 748BD69F6DC
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 15:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbjBVOnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 09:43:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231726AbjBVOnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 09:43:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E4B33A0A3
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 06:42:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677076927;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=acJBWLTZzvWzosBPFeaxGux+mQeksLVfPHDmqE5/HcU=;
        b=Zht9fWhlRFsSJX9Vk2TcF8QvkW3hvBJ7zsd+bnS/T3OpN7uluL0yqoda2Ulj+EB8frIZz6
        61QWaj+gAlJZ+DMY8ef11IbZZfzmZzjMi/kmk7wRN16JBcY3e0Kuw2JFHi7nUMru8IG7ds
        89XdDW3V0iFVCPzoN69cwU9bi985ygE=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-589-fyU9OKX0M-WEe0Yrskf1rA-1; Wed, 22 Feb 2023 09:42:04 -0500
X-MC-Unique: fyU9OKX0M-WEe0Yrskf1rA-1
Received: by mail-pj1-f71.google.com with SMTP id i6-20020a17090a650600b002372da4819eso1757135pjj.0
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 06:42:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=acJBWLTZzvWzosBPFeaxGux+mQeksLVfPHDmqE5/HcU=;
        b=WrHbDT9Xwwku7qjitmT56OItl1HAP5wbIn6RSNYZ0FcH2Fy/GWtynfC8HnoKBjsICk
         omIC7CDzPMXzlJmyardBojjx8mFo+3A7jSNY9B/qm5owlGhTvYtXeLB5xpDUGcVIXy38
         zbCjW3bLenBimrDOqP9Kewru4W2vrnl+2IgITUEG2ZA7Ouzcre1eQz9QVN/jiq6GU1Zu
         jCrTdZluhr8NFwuTQBOzNm+Kbh6IUWJmLkwg66xOhz2Y9ObLcsZgiMeRYXTl4THgVLG+
         UQnAaOqihYGEuWiFy9bpf0wSVsNlFWDNRqYTBVtR6i8QDfT3eDuMUfW2zVpapdPRgMph
         eZYg==
X-Gm-Message-State: AO0yUKUSiGhz2yYVul/8+ta4tfyRWGU8OEhxou9JfRUvMrZQ/T3svDGv
        dQsNcT3ryHoJSTdXuSexlNFW2+nHMau1KHzBA52WiQzPuwq82eUg8avWSx+es4A7/30D8Q3x2eD
        OKoLi3ibOoSIq1b9lvGv7Y73oeaFJ0Qvg
X-Received: by 2002:a17:902:ecd2:b0:199:4d19:600a with SMTP id a18-20020a170902ecd200b001994d19600amr1339818plh.29.1677076923019;
        Wed, 22 Feb 2023 06:42:03 -0800 (PST)
X-Google-Smtp-Source: AK7set/jFhAyVwrq+dV/IzWNCEdbskpKKqO3U0nYK3b43NStpRGO/cvM+cfiOU3DIgcr+Za25iB/R947iVOxmGcZGUI=
X-Received: by 2002:a17:902:ecd2:b0:199:4d19:600a with SMTP id
 a18-20020a170902ecd200b001994d19600amr1339810plh.29.1677076922745; Wed, 22
 Feb 2023 06:42:02 -0800 (PST)
MIME-Version: 1.0
References: <20230221125217.20775-1-ihuguet@redhat.com> <20230221125217.20775-4-ihuguet@redhat.com>
 <c5e64811-ba8a-58d3-77f6-6fd6d2ea7901@linux.dev>
In-Reply-To: <c5e64811-ba8a-58d3-77f6-6fd6d2ea7901@linux.dev>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Wed, 22 Feb 2023 15:41:51 +0100
Message-ID: <CACT4oudpiNkdrhzq4fHgnNgNJf1dOpA7w5DfZqo6OX1kgNpcmQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4 3/4] sfc: support unicast PTP
To:     Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, Yalin Li <yalli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 3:22 PM Vadim Fedorenko
<vadim.fedorenko@linux.dev> wrote:
> Not sure why do you want general packets to go to the queue for
> timestamping? There is no need for timestamp them in the protocol.
> The same question is for multicast version.

The reason is explained in a comment in efx_ptp_insert_multicast filters:
   Must filter on both event and general ports to ensure
   that there is no packet re-ordering

So the reason is not that we want the timestamp, but we want those
packets to go to the same RX queue. As a side effect, they will be
timestamped, yes, but as far as I know, there is no way to avoid that.

--=20
=C3=8D=C3=B1igo Huguet


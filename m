Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D330B6A09AD
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 14:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbjBWNJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 08:09:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233162AbjBWNJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 08:09:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80B41E9EC
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 05:08:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677157694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4BLGrjMnT5Udgl58mz9wqtjhvupLiDBpvyGIM82yE1c=;
        b=bMl4G9Z2aTrLweFDEYUKiA5iY+vS5d6ZW/QRvJGiYKb7dy6eQXjDLBtwFK1yRdZkT71sT3
        8CSV/BnS1prQPHpx+obCz6fbo/ufudRKZtnBJ1w3WyZhU0lnqPNYIoNmE6qxUet4P12IHz
        siDLAqoTKF81LETN08q+yKH+0a02r+Y=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-399-AoCdyodWPkyJ4rEpq21q5w-1; Thu, 23 Feb 2023 08:08:13 -0500
X-MC-Unique: AoCdyodWPkyJ4rEpq21q5w-1
Received: by mail-pg1-f197.google.com with SMTP id s187-20020a635ec4000000b00502f5c8f5eeso377779pgb.14
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 05:08:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4BLGrjMnT5Udgl58mz9wqtjhvupLiDBpvyGIM82yE1c=;
        b=OvwPIIwgUIdhxeSeNZkTrVmoAOqO7Y4ZFb0Vig0E3Xmjv6Tun7f3ZiN+BXfqwiV7tS
         EWWMEuHTRVpSOiTpGhH90Fd8jpvwTCyiYtydNN75eSdwQX568TUMNQrPlA61MXUrn7gw
         rzHCe+awlMjhqdRjW3ol7jV+oS+k8+68vnGhPFFNxjcLcWJM+h1YJJvab6IBjOaj+Po9
         OeI1Xi0iY/w7P0UuAn+3Xn1w3HF7xBcQxdytgrB2byoARswwcMS7q8lWb0dxK8GHHz2J
         6SdyeZe3nMWgI97hOqI2hzFoV922EUAxIermk2a8LOhqBllu5V+Tod6sfBhFyOicTtJk
         GLXg==
X-Gm-Message-State: AO0yUKVS36wvmJF8xSLW69+/xl5AmiHbVxxUuiHEDw18HlTzNOHdGlsA
        3AwyLw8JE+06+NvNIX3KFIE7YkEkkYx4KIaN3gLLbcoq9fvyPMK+DMLc921EfRn8987ipwwHsaX
        AAUj1TRvrSYl5P+fC30qtWPdikxCtRsqp
X-Received: by 2002:a17:90b:1e03:b0:230:b3dd:9c16 with SMTP id pg3-20020a17090b1e0300b00230b3dd9c16mr574178pjb.3.1677157692292;
        Thu, 23 Feb 2023 05:08:12 -0800 (PST)
X-Google-Smtp-Source: AK7set9b4KcnrFyNWe3CN52skeHUsNAd8RTauJamQLRy5aFbE7nj6tKpFkHZFsTeJ8tVygF0zHurlM3SrVlFMWcRWrQ=
X-Received: by 2002:a17:90b:1e03:b0:230:b3dd:9c16 with SMTP id
 pg3-20020a17090b1e0300b00230b3dd9c16mr574174pjb.3.1677157691942; Thu, 23 Feb
 2023 05:08:11 -0800 (PST)
MIME-Version: 1.0
References: <20230221125217.20775-1-ihuguet@redhat.com> <20230221125217.20775-4-ihuguet@redhat.com>
 <c5e64811-ba8a-58d3-77f6-6fd6d2ea7901@linux.dev> <CACT4oudpiNkdrhzq4fHgnNgNJf1dOpA7w5DfZqo6OX1kgNpcmQ@mail.gmail.com>
 <Y/ZIXRf1LEMBsV9r@hoboy.vegasvil.org>
In-Reply-To: <Y/ZIXRf1LEMBsV9r@hoboy.vegasvil.org>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Thu, 23 Feb 2023 14:08:00 +0100
Message-ID: <CACT4oucHWL=DLwkZo2CUjNSK+P77Bh2i-uBeRbP8m3QBY4qj0w@mail.gmail.com>
Subject: Re: [PATCH net-next v4 3/4] sfc: support unicast PTP
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Yalin Li <yalli@redhat.com>
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

On Wed, Feb 22, 2023 at 5:52 PM Richard Cochran
<richardcochran@gmail.com> wrote:
>
> On Wed, Feb 22, 2023 at 03:41:51PM +0100, =C3=8D=C3=B1igo Huguet wrote:
>
> > The reason is explained in a comment in efx_ptp_insert_multicast filter=
s:
> >    Must filter on both event and general ports to ensure
> >    that there is no packet re-ordering
>
> There is nothing wrong with re-ordering.  Nothing guarantees that
> datagrams are received in the order they are sent.
>
> The user space PTP stack must be handle out of order messages correct
> (which ptp4l does do BTW).

That's good to know, thanks.

Anyway,this patch set addresses the addition of Unicast PTP support,
and regarding the timestamping of PTP-general packets it has
maintained the existing driver behaviour. So I hope this is not a
blocker for the current patches, I think it should be addressed in a
different patch set if the time permits.

>
> Thanks,
> Richard
>


--=20
=C3=8D=C3=B1igo Huguet


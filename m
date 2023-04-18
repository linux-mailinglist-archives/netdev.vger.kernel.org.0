Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC6B06E6704
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 16:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232347AbjDROVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 10:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbjDROVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 10:21:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF61E65
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 07:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681827619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wTEgz5FFB3FlmpBtdJxi9kvXmr1g0kCkiAoUmPe0HM4=;
        b=SZrZcsttPIe9+OHScVXS3ICPqhNLY1okPYEvqHEnuPT3/SDVyev2KuhX4um3Lj+N0u6VV0
        R9bLA9TNXED32b0DBDDrcTZt9QyqZ38buj2DpUCmNrTlL/H+QqxrXjg6WIQVS/2OJmLtGk
        YwfgXMRFRGWyFKkkIqoDo3d3IdYcVFc=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-287-dtOFxBfcOryiWqC6WnRM0A-1; Tue, 18 Apr 2023 10:20:17 -0400
X-MC-Unique: dtOFxBfcOryiWqC6WnRM0A-1
Received: by mail-qt1-f198.google.com with SMTP id t27-20020a05622a181b00b003ef334999bfso3404973qtc.5
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 07:20:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681827617; x=1684419617;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wTEgz5FFB3FlmpBtdJxi9kvXmr1g0kCkiAoUmPe0HM4=;
        b=PBL0muMKIm/tO1iaDRRuDgZvsgRo14+gZlLYYUxGlqQfYS30ANc+3LYose0uCEg6Qy
         qSp23YFQMtcY0MWsf3SnlpOQFZPxv8VVrsaTLNCUS97nDKzxP3X9dieMm9FlGtuLCi46
         eHZFzczzk+AKbW3tCtjbpjDysW/BXpHQ1B1VOS75dC89NuHAS13oQQUjBeZQyBIZxvYn
         TrBu0RRIcMseK8q3tgkfr2uLbvuhSGWIXXQnGJVaQxPBhO9YhTRU4bXa8Q+RHLN1q40d
         pHxDy2A/xFIjNHuV44Npt6ZJCBYhvb3NHYmw8Q8ClynX/4P6CgwCDthrdn/cBwXfTBZa
         IaoQ==
X-Gm-Message-State: AAQBX9eUbXfpQGG0HG0NdFGPHsa8REUFjkCT6seW0rPvPFAsvYXtpMxH
        AfbG7uLXHTycecUdnbJoZWKBcRdbXsov+8+9YWaPExKpxa1uMoliajY+rFKhLjptUJTCqv3uii9
        UTamnpu910rbmz14q
X-Received: by 2002:a05:622a:295:b0:3eb:1082:ec93 with SMTP id z21-20020a05622a029500b003eb1082ec93mr21708222qtw.41.1681827617175;
        Tue, 18 Apr 2023 07:20:17 -0700 (PDT)
X-Google-Smtp-Source: AKy350bNyfIphFgQOXdbQ7b0I8+fgR55aExZiLfyClg34Zc0Jl2xZiTSAbBlkl2Gs52kSSuYH+mTfQ==
X-Received: by 2002:a05:622a:295:b0:3eb:1082:ec93 with SMTP id z21-20020a05622a029500b003eb1082ec93mr21708196qtw.41.1681827616954;
        Tue, 18 Apr 2023 07:20:16 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-229-200.dyn.eolo.it. [146.241.229.200])
        by smtp.gmail.com with ESMTPSA id w5-20020ac84d05000000b003ef28a76a11sm1704159qtv.68.2023.04.18.07.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 07:20:16 -0700 (PDT)
Message-ID: <ef0371ebc094e2c0778badca69ea0043b98589aa.camel@redhat.com>
Subject: Re: [PATCH linux-next 1/3] selftests: net: udpgso_bench_rx: Fix
 verifty exceptions
From:   Paolo Abeni <pabeni@redhat.com>
To:     Yang Yang <yang.yang29@zte.com.cn>, davem@davemloft.net,
        edumazet@google.com, willemdebruijn.kernel@gmail.com
Cc:     kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        shuah@kernel.org, zhang.yunkai@zte.com.cn, xu.xin16@zte.com.cn,
        Xuexin Jiang <jiang.xuexin@zte.com.cn>
Date:   Tue, 18 Apr 2023 16:20:12 +0200
In-Reply-To: <20230417122423.193237-1-yang.yang29@zte.com.cn>
References: <202304172017351308785@zte.com.cn>
         <20230417122423.193237-1-yang.yang29@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2023-04-17 at 20:24 +0800, Yang Yang wrote:
> From: Zhang Yunkai (CGEL ZTE) <zhang.yunkai@zte.com.cn>
>=20
> The verification function of this test case is likely to encounter the
> following error, which may confuse users.
>=20
> Executing the following command fails:
> bash# udpgso_bench_tx -l 4 -4 -D "$DST"
> bash# udpgso_bench_tx -l 4 -4 -D "$DST" -S 0
> bash# udpgso_bench_rx -4 -G -S 1472 -v
> udpgso_bench_rx: data[1472]: len 2944, a(97) !=3D q(113)


As noted by Willem, both the commit message and the above command
sequence is quite confusing. Please reorder the commands in the exact
sequence you run them, presumably:

udpgso_bench_rx -4 -G -S 1472 -v &
udpgso_bench_tx -l 4 -4 -D "$DST" -S 0


> This is because the sending buffers are not aligned by 26 bytes, and the
> GRO is not merged sequentially, and the receiver does not judge this
> situation. We do the validation after the data is split at the receiving
> end, just as the application actually uses this feature.

The wording from Willem response is much more clear. If applicable,
please use such text.

BTW I could not reproduce the issue with any permutation of the
suggested commands I could think of, so possibly that section need some
extra clarification.

Thanks,

Paolo


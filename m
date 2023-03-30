Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B493F6D0B93
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 18:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232212AbjC3QqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 12:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232089AbjC3QqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 12:46:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3231ECC3D
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 09:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680194717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TFvIWnrkfRarGJ21P6Zr1JqN3yDCAU1r0YnLOX6jVNo=;
        b=DXChuhjaXO/i34t29j/Mg9GDiyUi3F2BT/nJmaF/Ii2QUKQIwlCHdOUZf8II0wjNOduM62
        C4xD97LOJl1mvWSz4tIvukypZO+nDgc5SVNicEvyq49Au9W2865FCUbvBnptnDxUKZCPGG
        4HVblaNhI9qBtPQ+doQfQrWlk087V2M=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-358-qZYGi_sjPP61BomarDJrMA-1; Thu, 30 Mar 2023 12:45:16 -0400
X-MC-Unique: qZYGi_sjPP61BomarDJrMA-1
Received: by mail-qt1-f199.google.com with SMTP id y10-20020a05622a164a00b003e38e0a3cc3so12751658qtj.14
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 09:45:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680194714;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TFvIWnrkfRarGJ21P6Zr1JqN3yDCAU1r0YnLOX6jVNo=;
        b=eU1lwVxzZmJONH69C9pMHlRQM9w2Bf7Djh9orzhMMaRzORDET+GsFvMrRIzeFtjSd6
         RW/KHcNUXnFd067db6BNAYWMJ9n8+71npFk16Reamr+B9S2jkPvfRXQRqTaeRVRilptN
         65tX+oW0iR0cwbEwb3heW0Kv3Py7uYfsGd16p3XPigM9r35txIypbY7jBRu8sWvEWAIK
         gGwom4B5w8CMcaekfetHJBhDhgpDnXJrdk9Gnc0IQpTzedg6fidQh99bBYj7/z87ScaC
         9OCdhwS+TPbPDFpA0zlrxR60EwYQ0dKwclTHIJPyI1Kno5IRqpoDfhoRRRCfw4iv8r1R
         3D+A==
X-Gm-Message-State: AAQBX9cd9L5nwAggnlrulUqX+z5tfM0mIqM6TgOK7ujqXIN/lbGaGAQb
        pSHxUVjB2KaHv3eSdaFEDX09LcfL04ZtrGIMoBzFTm0edYeKHRYd6k6Z4wB6MabgVa/Z8rLT4zX
        enU2NQmJ5jPTMUekdpXqsKsUg
X-Received: by 2002:ac8:5f85:0:b0:3e4:635b:162f with SMTP id j5-20020ac85f85000000b003e4635b162fmr42612470qta.64.1680194713611;
        Thu, 30 Mar 2023 09:45:13 -0700 (PDT)
X-Google-Smtp-Source: AK7set/M6UVGGS4WYizjUxW1AyKk1DYMh8thz4hvPq63C4aXBG+ymKbtM6PcyjocIQgNDHkWCWWq8A==
X-Received: by 2002:ac8:5f85:0:b0:3e4:635b:162f with SMTP id j5-20020ac85f85000000b003e4635b162fmr42612425qta.64.1680194713364;
        Thu, 30 Mar 2023 09:45:13 -0700 (PDT)
Received: from [192.168.98.18] ([107.12.98.143])
        by smtp.gmail.com with ESMTPSA id t21-20020a37aa15000000b00746b7372d62sm8621075qke.27.2023.03.30.09.45.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Mar 2023 09:45:12 -0700 (PDT)
Message-ID: <301d2861-1390-eaea-4521-90d4dcfe7336@redhat.com>
Date:   Thu, 30 Mar 2023 12:45:11 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net 2/3] selftests: bonding: re-format bond option tests
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, Liang Li <liali@redhat.com>
References: <20230329101859.3458449-1-liuhangbin@gmail.com>
 <20230329101859.3458449-3-liuhangbin@gmail.com>
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <20230329101859.3458449-3-liuhangbin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/29/23 06:18, Hangbin Liu wrote:
> To improve the testing process for bond options, A new bond library is
> added to our testing setup. The current option_prio.sh file will be
> renamed to bond_options.sh so that all bonding options can be tested here.
> Specifically, for priority testing, we will run all tests using module
                                            I think you mean `modes`^^^
> 1, 5, and 6. These changes will help us streamline the testing process
> and ensure that our bond options are rigorously evaluated.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>   .../selftests/drivers/net/bonding/Makefile    |   3 +-
>   .../selftests/drivers/net/bonding/bond_lib.sh | 145 +++++++++++
>   .../drivers/net/bonding/bond_options.sh       | 216 +++++++++++++++
>   .../drivers/net/bonding/option_prio.sh        | 245 ------------------
>   4 files changed, 363 insertions(+), 246 deletions(-)
>   create mode 100644 tools/testing/selftests/drivers/net/bonding/bond_lib.sh
>   create mode 100755 tools/testing/selftests/drivers/net/bonding/bond_options.sh
>   delete mode 100755 tools/testing/selftests/drivers/net/bonding/option_prio.sh
> 
> diff --git a/tools/testing/selftests/drivers/net/bonding/Makefile b/tools/testing/selftests/drivers/net/bonding/Makefile
> index a39bb2560d9b..4683b06afdba 100644
> --- a/tools/testing/selftests/drivers/net/bonding/Makefile
> +++ b/tools/testing/selftests/drivers/net/bonding/Makefile
> @@ -8,11 +8,12 @@ TEST_PROGS := \
>   	dev_addr_lists.sh \
>   	mode-1-recovery-updelay.sh \
>   	mode-2-recovery-updelay.sh \
> -	option_prio.sh \
> +	bond_options.sh \
>   	bond-eth-type-change.sh
>   
>   TEST_FILES := \
>   	lag_lib.sh \
> +	bond_lib.sh \
>   	net_forwarding_lib.sh
>   
>   include ../../../lib.mk
> diff --git a/tools/testing/selftests/drivers/net/bonding/bond_lib.sh b/tools/testing/selftests/drivers/net/bonding/bond_lib.sh
> new file mode 100644
> index 000000000000..ca64a82e1385
> --- /dev/null
> +++ b/tools/testing/selftests/drivers/net/bonding/bond_lib.sh

I like this idea, we might want to separate network topology from 
library code however. That way a given test case can just include a 
predefined topology. A quick review of the test cases show a 2 node 
setup is the most common across all test cases.

-Jon


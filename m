Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0D66BB664
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 15:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbjCOOp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 10:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbjCOOpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 10:45:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF3B4D29B
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 07:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678891473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V9DO5/qhW6U1QCthKzhHp/6zXZOJTXt3N7Wz9ZLGVs8=;
        b=WDttGvZ+BQpj1T8rdXxi6xkhQ+sbtgN1fp7bvJTXZBsU8cZv8vQ9CvSHHNjeg/FwrH4Wku
        hPI0fqcC1c6VVWr7f4nn7qCKtF5GNBMnjLnVW8Q4WKeWNDwphbNxyAJjJdpoFvT1npEz0t
        4O4Lp12MdAjBd981sYkFJQAP+Q3r3jE=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-GDNGh18UNNCL-6K7f3Jd8w-1; Wed, 15 Mar 2023 10:44:32 -0400
X-MC-Unique: GDNGh18UNNCL-6K7f3Jd8w-1
Received: by mail-qt1-f198.google.com with SMTP id c5-20020ac84e05000000b003d6a808a388so116939qtw.8
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 07:44:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678891468;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V9DO5/qhW6U1QCthKzhHp/6zXZOJTXt3N7Wz9ZLGVs8=;
        b=TRq3K4J35cFZ6fe5Qovy2AvFYKBxYzDLoByFaAHR/SM8HsSny1ddcrR+jt3yYo8qNF
         rTx75gPRLC6DHcwHMfQsZ4OllXpbh4me7bITEk4BQnEthyvD25vWRFKffb7Ku+X1//eB
         /wZB2RgOFIWArIWojvpAjmXfu2npdGsJPFiHRyy5MMuO+APBTvX7OBNXK0JH8YLa77uS
         SDHTq2aeR61WtGAkjX17wjcoS5t1GSwC7N51YocdyZc7D1gZKK77dGoimVuXvmGmC8YX
         tMdqoOk/IT7+e3lRpyyTPmkAl6ushYCk5fE7gCXvolxv7kaon5VqEywSM1cM2wBhsxlZ
         N3tA==
X-Gm-Message-State: AO0yUKWo8P186VZAhwVgqjR0Hw1amjbjpmd6J46t/QXW7pUMAKws8taG
        H7Mza3E7Vc7PbJ3bB/D8ACe0GUf1OVmLCa+KHKBXs6AMxXu8W+rhw2hy9U6o3zptx5A34ozn4Ng
        GXR2YswKVXZKBagSa
X-Received: by 2002:a05:622a:1443:b0:3bf:d7f8:4f85 with SMTP id v3-20020a05622a144300b003bfd7f84f85mr250308qtx.12.1678891468406;
        Wed, 15 Mar 2023 07:44:28 -0700 (PDT)
X-Google-Smtp-Source: AK7set81sK96A7z7pEl6MJGG5bAQyWj2G3woDPKd14dVFfwYI2+6BEGTfADHJpbb+lpInVBEP8Arpw==
X-Received: by 2002:a05:622a:1443:b0:3bf:d7f8:4f85 with SMTP id v3-20020a05622a144300b003bfd7f84f85mr250282qtx.12.1678891468141;
        Wed, 15 Mar 2023 07:44:28 -0700 (PDT)
Received: from [192.168.98.18] ([107.12.98.143])
        by smtp.gmail.com with ESMTPSA id d9-20020ae9ef09000000b0073ba211e765sm3846432qkg.19.2023.03.15.07.44.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 07:44:27 -0700 (PDT)
Message-ID: <0cfd57e7-2993-1bba-1918-022fe0e70930@redhat.com>
Date:   Wed, 15 Mar 2023 10:44:26 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net v3 0/3] bonding: properly restore flags when bond
 changes ether type
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     monis@voltaire.com, syoshida@redhat.com, j.vosburgh@gmail.com,
        andy@greyhouse.net, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com,
        syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com,
        michal.kubiak@intel.com
References: <20230315111842.1589296-1-razor@blackwall.org>
Content-Language: en-US
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <20230315111842.1589296-1-razor@blackwall.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/15/23 07:18, Nikolay Aleksandrov wrote:
> Hi,
> A bug was reported by syzbot[1] that causes a warning and a myriad of
> other potential issues if a bond, that is also a slave, fails to enslave a
> non-eth device. While fixing that bug I found that we have the same
> issues when such enslave passes and after that the bond changes back to
> ARPHRD_ETHER (again due to ether_setup). This set fixes all issues by
> extracting the ether_setup() sequence in a helper which does the right
> thing about bond flags when it needs to change back to ARPHRD_ETHER. It
> also adds selftests for these cases.
> 
> Patch 01 adds the new bond_ether_setup helper and fixes the issues when a
> bond device changes its ether type due to successful enslave. Patch 02
> fixes the issues when it changes its ether type due to an unsuccessful
> enslave. Note we need two patches because the bugs were introduced by
> different commits. Patch 03 adds the new selftests.
> 
> Due to the comment adjustment and squash, could you please review
> patch 01 again? I've kept the other acks since there were no code
> changes.
> 
> v3: squash the helper patch and the first fix, adjust the comment above
>      it to be explicit about the bond device, no code changes
> v2: new set, all patches are new due to new approach of fixing these bugs
> 
> Thanks,
>   Nik
> 
> [1] https://syzkaller.appspot.com/bug?id=391c7b1f6522182899efba27d891f1743e8eb3ef
> 
> Nikolay Aleksandrov (3):
>    bonding: restore IFF_MASTER/SLAVE flags on bond enslave ether type
>      change
>    bonding: restore bond's IFF_SLAVE flag if a non-eth dev enslave fails
>    selftests: bonding: add tests for ether type changes
> 
>   drivers/net/bonding/bond_main.c               | 23 +++--
>   .../selftests/drivers/net/bonding/Makefile    |  3 +-
>   .../net/bonding/bond-eth-type-change.sh       | 85 +++++++++++++++++++
>   3 files changed, 103 insertions(+), 8 deletions(-)
>   create mode 100755 tools/testing/selftests/drivers/net/bonding/bond-eth-type-change.sh
> 

    For the series.
Acked-by: Jonathan Toppins <jtoppins@redhat.com>


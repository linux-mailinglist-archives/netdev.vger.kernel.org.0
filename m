Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93B0063CA63
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 22:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236889AbiK2VO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 16:14:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236874AbiK2VO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 16:14:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8EC32BB0F
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 13:13:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669756426;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d30QTxTORkW1N9eKwj6M+zoNiUdizDE1AT68blPInq4=;
        b=gboecGvtyDN0DLH9sLTkkXTR6SCdLvisvOgvxq1bnbI5h1dFRbQRHfXmtqLHanorCDY50I
        uX63xEJuMhqVMFrVfj7lEMYEYI5zKd5o91BAVxqlgOsCjhAbAc1pXXj80kSBfCKVNp/KQX
        Se5mgbjjU0HEwY5vtOe0p05f/AhQG/A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-aiGqA2bEOSuJ6sHhQ3xVHg-1; Tue, 29 Nov 2022 16:13:39 -0500
X-MC-Unique: aiGqA2bEOSuJ6sHhQ3xVHg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B4C94802314;
        Tue, 29 Nov 2022 21:13:38 +0000 (UTC)
Received: from [10.22.17.30] (unknown [10.22.17.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E4E640C83AA;
        Tue, 29 Nov 2022 21:13:37 +0000 (UTC)
Message-ID: <51c23d0e-9f00-4433-f2e8-95113f0b2a9d@redhat.com>
Date:   Tue, 29 Nov 2022 16:13:35 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [net-next] bpf: avoid hashtab deadlock with try_lock
Content-Language: en-US
To:     Hao Luo <haoluo@google.com>, Boqun Feng <boqun.feng@gmail.com>
Cc:     Hou Tao <houtao@huaweicloud.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Jiri Olsa <jolsa@kernel.org>, bpf <bpf@vger.kernel.org>,
        "houtao1@huawei.com" <houtao1@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <41eda0ea-0ed4-1ffb-5520-06fda08e5d38@huawei.com>
 <CAMDZJNVSv3Msxw=5PRiXyO8bxNsA-4KyxU8BMCVyHxH-3iuq2Q@mail.gmail.com>
 <fdb3b69c-a29c-2d5b-a122-9d98ea387fda@huawei.com>
 <CAMDZJNWTry2eF_n41a13tKFFSSLFyp3BVKakOOWhSDApdp0f=w@mail.gmail.com>
 <CA+khW7jgsyFgBqU7hCzZiSSANE7f=A+M-0XbcKApz6Nr-ZnZDg@mail.gmail.com>
 <07a7491e-f391-a9b2-047e-cab5f23decc5@huawei.com>
 <CAMDZJNUTaiXMe460P7a7NfK1_bbaahpvi3Q9X85o=G7v9x-w=g@mail.gmail.com>
 <59fc54b7-c276-2918-6741-804634337881@huaweicloud.com>
 <541aa740-dcf3-35f5-9f9b-e411978eaa06@redhat.com>
 <Y4ZABpDSs4/uRutC@Boquns-Mac-mini.local>
 <Y4ZCKaQFqDY3aLTy@Boquns-Mac-mini.local>
 <CA+khW7hkQRFcC1QgGxEK_NeaVvCe3Hbe_mZ-_UkQKaBaqnOLEQ@mail.gmail.com>
From:   Waiman Long <longman@redhat.com>
In-Reply-To: <CA+khW7hkQRFcC1QgGxEK_NeaVvCe3Hbe_mZ-_UkQKaBaqnOLEQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/29/22 14:36, Hao Luo wrote:
> On Tue, Nov 29, 2022 at 9:32 AM Boqun Feng <boqun.feng@gmail.com> wrote:
>> Just to be clear, I meant to refactor htab_lock_bucket() into a try
>> lock pattern. Also after a second thought, the below suggestion doesn't
>> work. I think the proper way is to make htab_lock_bucket() as a
>> raw_spin_trylock_irqsave().
>>
>> Regards,
>> Boqun
>>
> The potential deadlock happens when the lock is contended from the
> same cpu. When the lock is contended from a remote cpu, we would like
> the remote cpu to spin and wait, instead of giving up immediately. As
> this gives better throughput. So replacing the current
> raw_spin_lock_irqsave() with trylock sacrifices this performance gain.
>
> I suspect the source of the problem is the 'hash' that we used in
> htab_lock_bucket(). The 'hash' is derived from the 'key', I wonder
> whether we should use a hash derived from 'bucket' rather than from
> 'key'. For example, from the memory address of the 'bucket'. Because,
> different keys may fall into the same bucket, but yield different
> hashes. If the same bucket can never have two different 'hashes' here,
> the map_locked check should behave as intended. Also because
> ->map_locked is per-cpu, execution flows from two different cpus can
> both pass.

I would suggest that you add a in_nmi() check and if true use trylock to 
get the lock. You can continue to use raw_spin_lock_irqsave() in all 
other cases.

Cheers,
Longman


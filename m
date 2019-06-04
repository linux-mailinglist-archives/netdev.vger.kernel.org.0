Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1832A34BAE
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 17:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbfFDPMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 11:12:46 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:60577 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727790AbfFDPMq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 11:12:46 -0400
Received: from tarshish (unknown [10.0.8.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id B0B5644059C;
        Tue,  4 Jun 2019 18:12:43 +0300 (IDT)
References: <f42c7b44b3f694056c4216e9d9ba914b44e72ab9.1559648367.git.baruch@tkos.co.il> <CAMuHMdWbcSUyYo1sJ81qojmbB_g595dVnzQycZq0Yh5BdQYCEg@mail.gmail.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Baruch Siach <baruch@tkos.co.il>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        "Dmitry V . Levin" <ldv@altlinux.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] bpf: fix uapi bpf_prog_info fields alignment
In-reply-to: <CAMuHMdWbcSUyYo1sJ81qojmbB_g595dVnzQycZq0Yh5BdQYCEg@mail.gmail.com>
Date:   Tue, 04 Jun 2019 18:12:43 +0300
Message-ID: <87ftopo044.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

On Tue, Jun 04 2019, Geert Uytterhoeven wrote:
> On Tue, Jun 4, 2019 at 1:40 PM Baruch Siach <baruch@tkos.co.il> wrote:
>> Merge commit 1c8c5a9d38f60 ("Merge
>> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next") undid the
>> fix from commit 36f9814a494 ("bpf: fix uapi hole for 32 bit compat
>> applications") by taking the gpl_compatible 1-bit field definition from
>> commit b85fab0e67b162 ("bpf: Add gpl_compatible flag to struct
>> bpf_prog_info") as is. That breaks architectures with 16-bit alignment
>> like m68k. Widen gpl_compatible to 32-bit to restore alignment of the
>> following fields.
>>
>> Thanks to Dmitry V. Levin his analysis of this bug history.
>>
>> Cc: Jiri Olsa <jolsa@kernel.org>
>> Cc: Daniel Borkmann <daniel@iogearbox.net>
>> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
>> Cc: Linus Torvalds <torvalds@linux-foundation.org>
>> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
>
> Thanks for your patch!
>
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -3140,7 +3140,7 @@ struct bpf_prog_info {
>>         __aligned_u64 map_ids;
>>         char name[BPF_OBJ_NAME_LEN];
>>         __u32 ifindex;
>> -       __u32 gpl_compatible:1;
>> +       __u32 gpl_compatible;
>>         __u64 netns_dev;
>>         __u64 netns_ino;
>
> Wouldn't it be better to change the types of the fields that require
> 8-byte alignment from __u64 to __aligned_u64, like is already used
> for the map_ids fields?
>
> Without that, some day people will need to add a new flag, and will
> convert the 32-bit flag to a bitfield again to make space, reintroducing
> the issue.

This is a minimal fix that restores the original fix of commit
36f9814a494. Would __aligned_u64 cause any negative side effect on
current ABI?

baruch

>>         __u32 nr_jited_ksyms;
>> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
>> index 63e0cf66f01a..fe73829b5b1c 100644
>> --- a/tools/include/uapi/linux/bpf.h
>> +++ b/tools/include/uapi/linux/bpf.h
>> @@ -3140,7 +3140,7 @@ struct bpf_prog_info {
>>         __aligned_u64 map_ids;
>>         char name[BPF_OBJ_NAME_LEN];
>>         __u32 ifindex;
>> -       __u32 gpl_compatible:1;
>> +       __u32 gpl_compatible;
>>         __u64 netns_dev;
>>         __u64 netns_ino;
>
> Same here.
>
>>         __u32 nr_jited_ksyms;

--
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -

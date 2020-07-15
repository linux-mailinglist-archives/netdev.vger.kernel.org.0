Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33352221516
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 21:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgGOT05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 15:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgGOT04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 15:26:56 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C54F5C061755
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 12:26:55 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id h19so3863336ljg.13
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 12:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=kzbzpm5bB6bS9+lS/zExrNVYA3+yxaz4423kZEYiffU=;
        b=gqHjubeI5enLofHe4KaZWHqr7078/9KkvbRfM76e3a/AVhPZgEz12Ob/xS18epoZ+q
         UmxorDT4aJv0C03efjVrwpBxPJ/SHtu4+GnLyqDf3lbnfG2nGJ5ycWE9/pCUFZoWfzKH
         noz8YNhxzMEfG+SCxZ3tPTHDOSKQQa5ExKurw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=kzbzpm5bB6bS9+lS/zExrNVYA3+yxaz4423kZEYiffU=;
        b=I6No5U3gQpxqVzSKTyI8oxQLZlmOU0Hlppbo5ggciwZM4ptVfTUNMnYsjh7upqDX4P
         0c+SlGdVrXKD3HHXZxCY+AaKdLOr9ZpnM+hnNXu9yw0WjUjQOh2DpYWHm0L0Xcrz2EnI
         WirIX/5CSa0efVS2w8axeuSuAE1k/zY0R+Tq6HDesEzdLMllJVOVwrRXE+qLbRFAuGgS
         RoEkSLL8GjR1cnhz5W8PfAM6Vk+tz1jSIactH4S1o0K7vI3svi/79sykDlwBHw50glo4
         xa1EGo4cgu8FAH/kINxKwHdSOcxI90PosNjWReES0/+7uEqu88xk/0WIzfpuUtxeDhSq
         hAyQ==
X-Gm-Message-State: AOAM5339BgTPxdOhD4r95J1uku+bkrhJR2Ofo33LWhG2GV/peYV+OEn1
        fN22uNlQshbzXFZKOYqIBArbgg==
X-Google-Smtp-Source: ABdhPJyQlBfH1wWM32Z9X6e98oLR6zIoCb2XAaraDU3Cqp2zci+fMh+RwIHis06sE94inv7GzQK8KQ==
X-Received: by 2002:a2e:5cc6:: with SMTP id q189mr269364ljb.251.1594841214072;
        Wed, 15 Jul 2020 12:26:54 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id y21sm609563ljm.30.2020.07.15.12.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 12:26:53 -0700 (PDT)
References: <20200710173123.427983-1-jakub@cloudflare.com> <c98aaa5e-9347-c23f-cfa6-e267f2485c5b@fb.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH bpf] bpf: Shift and mask loads narrower than context field size
In-reply-to: <c98aaa5e-9347-c23f-cfa6-e267f2485c5b@fb.com>
Date:   Wed, 15 Jul 2020 21:26:52 +0200
Message-ID: <87a700y3yb.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 08:44 AM CEST, Yonghong Song wrote:
> On 7/10/20 10:31 AM, Jakub Sitnicki wrote:
>> When size of load from context is the same as target field size, but less
>> than context field size, the verifier does not emit the shift and mask
>> instructions for loads at non-zero offset.
>>
>> This has the unexpected effect of loading the same data no matter what the
>> offset was. While the expected behavior would be to load zeros for offsets
>> that are greater than target field size.
>>
>> For instance, u16 load from u32 context field backed by u16 target field at
>> an offset of 2 bytes results in:
>>
>>    SEC("sk_reuseport/narrow_half")
>>    int reuseport_narrow_half(struct sk_reuseport_md *ctx)
>>    {
>>    	__u16 *half;
>>
>>    	half = (__u16 *)&ctx->ip_protocol;
>>    	if (half[0] == 0xaaaa)
>>    		return SK_DROP;
>>    	if (half[1] == 0xbbbb)
>>    		return SK_DROP;
>>    	return SK_PASS;
>>    }
>
> It would be good if you can include llvm asm output like below so people
> can correlate source => asm => xlated codes:
>
>        0:       w0 = 0
>        1:       r2 = *(u16 *)(r1 + 24)
>        2:       if w2 == 43690 goto +4 <LBB0_3>
>        3:       r1 = *(u16 *)(r1 + 26)
>        4:       w0 = 1
>        5:       if w1 != 48059 goto +1 <LBB0_3>
>        6:       w0 = 0
>
> 0000000000000038 <LBB0_3>:
>        7:       exit

Sure, not a problem, if it makes reasoning about the problem easier.
I'm assuming that it is the narrow load at an offset that you wanted to
confirm with asm output.

>
>>
>>    int reuseport_narrow_half(struct sk_reuseport_md * ctx):
>>    ; int reuseport_narrow_half(struct sk_reuseport_md *ctx)
>>       0: (b4) w0 = 0
>>    ; if (half[0] == 0xaaaa)
>>       1: (79) r2 = *(u64 *)(r1 +8)
>>       2: (69) r2 = *(u16 *)(r2 +924)
>>    ; if (half[0] == 0xaaaa)
>>       3: (16) if w2 == 0xaaaa goto pc+5
>>    ; if (half[1] == 0xbbbb)
>>       4: (79) r1 = *(u64 *)(r1 +8)
>>       5: (69) r1 = *(u16 *)(r1 +924)
>>       6: (b4) w0 = 1
>>    ; if (half[1] == 0xbbbb)
>>       7: (56) if w1 != 0xbbbb goto pc+1
>>       8: (b4) w0 = 0
>>    ; }
>>       9: (95) exit
>
> Indeed we have an issue here. The insn 5 is not correct.
> The original assembly is correct.
>
> Internally ip_protocol is backed by 2 bytes in sk_reuseport_kern.
> The current verifier implementation makes an important assumption:
>    all user load requests are within the size of kernel internal range
> In this case, the verifier actually only correctly supports
>    . one byte from offset 0
>    . one byte from offset 1
>    . two bytes from offset 0

I don't think that's true. For a field that has target size of 2 bytes,
like ip_protocol, 1-byte load at any offset is correctly supported
because right shifting and masking takes place. That is because we hit
the "size < target_size" condition in this case. Only loads of size >=
target size at an offset != give surprising results.

>
> The original assembly code tries to access 2 bytes from offset 2
> and the verifier did incorrect transformation.
>
> This actually makes sense since any other read is
> misleading. For example, for ip_protocol, if people wants to
> load 2 bytes from offset 2, what should we return? 0? In this case,
> actually verifier can convert it to 0 with doing a load.

Yes, IMHO, if you are loading 2 bytes at offset of 2 from a 4 byte
context field that holds an unsigned value, then it should return 0 for
for a field that is backed by a 2 byte kernel field.

I agree that it could be optimized to load an immediate value instead of
performing a load from memory. It didn't occur to me, so thanks for the
suggestion.

>> In this case half[0] == half[1] == sk->sk_protocol that backs the
>> ctx->ip_protocol field.
>>
>> Fix it by shifting and masking any load from context that is narrower than
>> context field size (is_narrower_load = size < ctx_field_size), in addition
>> to loads that are narrower than target field size.
>
> The fix can workaround the issue, but I think we should generate better codes
> for such cases.

Not sure I'd go as far as calling it a workaround. After all I
understand that in BPF loading a half word into a register is well
defined, and you can rely on upper word being zero. But please correct
me if not.

You're right, though, that approach can be smarter here, that is we can
emit just a single instruction that doesn't access memory.

>> The "size < target_size" check is left in place to cover the case when a
>> context field is narrower than its target field, even if we might not have
>> such case now. (It would have to be a u32 context field backed by a u64
>> target field, with context fields all being 4-bytes or wider.)
>>
>> Going back to the example, with the fix in place, the upper half load from
>> ctx->ip_protocol yields zero:
>>
>>    int reuseport_narrow_half(struct sk_reuseport_md * ctx):
>>    ; int reuseport_narrow_half(struct sk_reuseport_md *ctx)
>>       0: (b4) w0 = 0
>>    ; if (half[0] == 0xaaaa)
>>       1: (79) r2 = *(u64 *)(r1 +8)
>>       2: (69) r2 = *(u16 *)(r2 +924)
>>       3: (54) w2 &= 65535
>>    ; if (half[0] == 0xaaaa)
>>       4: (16) if w2 == 0xaaaa goto pc+7
>>    ; if (half[1] == 0xbbbb)
>>       5: (79) r1 = *(u64 *)(r1 +8)
>>       6: (69) r1 = *(u16 *)(r1 +924)
>
> The load is still from offset 0, 2 bytes with upper 48 bits as 0.

Yes, this is how narrow loads currently work, right? It is not specific
to the case I'm fixing.

To give an example - if you do a 1-byte load at offset 1, it will load
the value from offset 0, and shift it right by 1 byte. So it is expected
that the load is always from offset 0 with current implementation.

SEC("sk_reuseport/narrow_byte")
int reuseport_narrow_byte(struct sk_reuseport_md *ctx)
{
	__u8 *byte;

	byte = (__u8 *)&ctx->ip_protocol;
	if (byte[0] == 0xaa)
		return SK_DROP;
	if (byte[1] == 0xbb)
		return SK_DROP;
	if (byte[2] == 0xcc)
		return SK_DROP;
	if (byte[3] == 0xdd)
		return SK_DROP;
	return SK_PASS;
}

int reuseport_narrow_byte(struct sk_reuseport_md * ctx):
; int reuseport_narrow_byte(struct sk_reuseport_md *ctx)
   0: (b4) w0 = 0
; if (byte[0] == 0xaa)
   1: (79) r2 = *(u64 *)(r1 +8)
   2: (69) r2 = *(u16 *)(r2 +924)
   3: (54) w2 &= 255
; if (byte[0] == 0xaa)
   4: (16) if w2 == 0xaa goto pc+17
; if (byte[1] == 0xbb)
   5: (79) r2 = *(u64 *)(r1 +8)
   6: (69) r2 = *(u16 *)(r2 +924)
   7: (74) w2 >>= 8
   8: (54) w2 &= 255
; if (byte[1] == 0xbb)
   9: (16) if w2 == 0xbb goto pc+12
; if (byte[2] == 0xcc)
  10: (79) r2 = *(u64 *)(r1 +8)
  11: (69) r2 = *(u16 *)(r2 +924)
  12: (74) w2 >>= 16
  13: (54) w2 &= 255
; if (byte[2] == 0xcc)
  14: (16) if w2 == 0xcc goto pc+7
; if (byte[3] == 0xdd)
  15: (79) r1 = *(u64 *)(r1 +8)
  16: (69) r1 = *(u16 *)(r1 +924)
  17: (74) w1 >>= 24
  18: (54) w1 &= 255
  19: (b4) w0 = 1
; if (byte[3] == 0xdd)
  20: (56) if w1 != 0xdd goto pc+1
  21: (b4) w0 = 0
; }
  22: (95) exit

>
>>       7: (74) w1 >>= 16
>
> w1 will be 0 now. so this will work.
>
>>       8: (54) w1 &= 65535
>
> For the above insns 5-8, verifier, based on target information can
> directly generate w1 = 0 since:
>   . target kernel field size is 2, ctx field size is 4.
>   . user tries to access offset 2 size 2.
>
> Here, we need to decide whether we permits user to do partial read beyond of
> kernel narrow field or not (e.g., this example)? I would
> say yes, but Daniel or Alexei can provide additional comments.
>
> If we allow such accesses, I would like verifier to generate better
> code as I illustrated in the above. This can be implemented in
> verifier itself with target passing additional kernel field size
> to the verifier. The target already passed the ctx field size back
> to the verifier.

Keep in mind that the BPF user is writing their code under the
assumption that the context field has 4 bytes. IMHO it's reasonable to
expect that I can load 2 bytes at offset of 2 from a 4 byte field.

Restricting it now to loads below the target field size, which is
unknown to the user, would mean rejecting programs that are working
today. Even if they are getting funny values.

I think implementing what you suggest is doable without major
changes. We have load size, target field size, and context field size at
hand in convert_ctx_accesses(), so it seems like a matter of adding an
'if' branch to handle better the case when we know the end result must
be 0. I'll give it a try.

But I do want to empahsize that I still think the fix in current form is
correct, or at least not worse than what we have already in place narrow
loads.

>
>>       9: (b4) w0 = 1
>>    ; if (half[1] == 0xbbbb)
>>      10: (56) if w1 != 0xbbbb goto pc+1
>>      11: (b4) w0 = 0
>>    ; }
>>      12: (95) exit
>>
>> Fixes: f96da09473b5 ("bpf: simplify narrower ctx access")
>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> ---
>>   kernel/bpf/verifier.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index 94cead5a43e5..1c4d0e24a5a2 100644
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@ -9760,7 +9760,7 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
>>   			return -EINVAL;
>>   		}
>>   -		if (is_narrower_load && size < target_size) {
>> +		if (is_narrower_load || size < target_size) {
>>   			u8 shift = bpf_ctx_narrow_access_offset(
>>   				off, size, size_default) * 8;
>>   			if (ctx_field_size <= 4) {
>>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04ADA22F318
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 16:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730082AbgG0OxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 10:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728593AbgG0OxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 10:53:22 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF1EC0619D2
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 07:53:22 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id g10so13560167wmc.1
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 07:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=e3peqWH1NUrLQkjIphZbD3LAaLz4BF4zAFhtCds/KAI=;
        b=KBKv3neaWqO/JUoiF6DF9xtZqMyqxpvhEnSn6g6rJ14ZIYlHSF4YIoMZm4NJmoBQiZ
         YYh73ZtwMfdbpj8388kRDgeT0xhB+n+vLT52WK38raOLAHBxpOEq7zKuti+/fiV21hTM
         qcDfdLsWcQLGzzbOE7OXgJZZz+kYDa59Zs4TI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=e3peqWH1NUrLQkjIphZbD3LAaLz4BF4zAFhtCds/KAI=;
        b=nREWDX3SD2RxXQizJFJidqzJj47zIBAUz4ralls6F/eWLtvdbU8Eix/Bt9jZX4lh0k
         0A/o+ydOm8fa4NFvjhlzvU1pKgCH/ttcucolP2oAOkQ2rf5+mX5whB890Pv2PMjorMhf
         pcQXUiX7LEkq/VbcMKZ0A7SQtLhwQvTYAkBGAQzRZB02KZYDtLUDIOBqvg3NJs6DUnja
         wNHdCGDLDmYIkZKg/LA0mUBmOwOoJfrXGoHbHALJqyz3/y/L6RTqdgsSBZV1RjU6niY7
         h0524ZpCDDKXxrsd1wAURxVaklAl6FWdimPWH+sIHSv/M0+ar2NN23EMpbKXyDxO9/UK
         bgEw==
X-Gm-Message-State: AOAM531tohxxqkLHgbdJWXs2WjJbyNLG8TMQnX/CvetIreP9VJVYSmT0
        UFHbiWeQ+SmqQzL8Y4M1rdwv6A==
X-Google-Smtp-Source: ABdhPJxRp1LyQvC3RbC3/YkrMbNeKyRjifWH1QFeeg4r9CzNJhoLOP/OApiq+lNeN3+FZoHOP5lCCg==
X-Received: by 2002:a1c:b6c4:: with SMTP id g187mr12282303wmf.149.1595861601325;
        Mon, 27 Jul 2020 07:53:21 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id u186sm18684188wmu.10.2020.07.27.07.53.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 07:53:20 -0700 (PDT)
References: <20200723095953.1003302-1-jakub@cloudflare.com> <20200723095953.1003302-2-jakub@cloudflare.com> <822d5ee4-e507-22fc-a27d-60b5f0f2c5f2@fb.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH bpf v2 1/2] bpf: Load zeros for narrow loads beyond target field
In-reply-to: <822d5ee4-e507-22fc-a27d-60b5f0f2c5f2@fb.com>
Date:   Mon, 27 Jul 2020 16:53:19 +0200
Message-ID: <87r1sxvwkg.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 11:56 PM CEST, Yonghong Song wrote:
> On 7/23/20 2:59 AM, Jakub Sitnicki wrote:
>> For narrow loads from context that are:
>>
>>    1) as big in size as the target field, and
>>    2) at an offset beyond the target field,
>>
>> the verifier does not emit the shift-and-mask instruction sequence
>> following the target field load instruction, as it happens for narrow loads
>> smaller in size than the target field width.
>>
>> This has an unexpected effect of loading the same data, no matter what the
>> offset. While, arguably, the expected behavior is to load zeros for offsets
>> that beyond the target field.
>>
>> For instance, 2-byte load from a 4-byte context field, backed by a 2-byte
>> target field at an offset of 2 bytes results in:
>>
>>    $ cat progs/test_narrow_load.c
>>    [...]
>>    SEC("sk_reuseport/narrow_load_half_word")
>>    int narrow_load_half_word(struct sk_reuseport_md *ctx)
>>    {
>>    	__u16 *half;
>>
>>    	half = (__u16 *)&ctx->ip_protocol;
>>    	if (half[0] != IPPROTO_UDP)
>>    		return SK_DROP;
>>    	if (half[1] != 0)
>>    		return SK_DROP;
>>    	return SK_PASS;
>>    }
>>
>>    $ llvm-objdump -S --no-show-raw-insn ...
>>    [...]
>>    0000000000000000 narrow_load_half_word:
>>    ; {
>>           0:       w0 = 0
>>    ;       if (half[0] != IPPROTO_UDP)
>>           1:       r2 = *(u16 *)(r1 + 24)
>>           2:       if w2 != 17 goto +4 <LBB1_3>
>>    ;       if (half[1] != 0)
>>           3:       r1 = *(u16 *)(r1 + 26)
>>           4:       w0 = 1
>>           5:       if w1 == 0 goto +1 <LBB1_3>
>>           6:       w0 = 0
>>
>>    0000000000000038 LBB1_3:
>>    ; }
>>           7:       exit
>>
>>    $ bpftool prog dump xlated ...
>>    int narrow_load_half_word(struct sk_reuseport_md * ctx):
>>    ; int narrow_load_half_word(struct sk_reuseport_md *ctx)
>>       0: (b4) w0 = 0
>>    ; if (half[0] != IPPROTO_UDP)
>>       1: (79) r2 = *(u64 *)(r1 +8)
>>       2: (69) r2 = *(u16 *)(r2 +924)
>>    ; if (half[0] != IPPROTO_UDP)
>>       3: (56) if w2 != 0x11 goto pc+5
>>    ; if (half[1] != 0)
>>       4: (79) r1 = *(u64 *)(r1 +8)
>>       5: (69) r1 = *(u16 *)(r1 +924)
>>       6: (b4) w0 = 1
>>    ; if (half[1] != 0)
>>       7: (16) if w1 == 0x0 goto pc+1
>>       8: (b4) w0 = 0
>>    ; }
>>       9: (95) exit
>>
>> In this case half[0] == half[1] == sk->sk_protocol, which is the target
>> field for the ctx->ip_protocol.
>>
>> Fix it by emitting 'wX = 0' or 'rX = 0' instruction for all narrow loads
>> from an offset that is beyond the target field.
>>
>> Going back to the example, with the fix in place, the upper half load from
>> ctx->ip_protocol yields zero:
>>
>>    int narrow_load_half_word(struct sk_reuseport_md * ctx):
>>    ; int narrow_load_half_word(struct sk_reuseport_md *ctx)
>>       0: (b4) w0 = 0
>>    ; if (half[0] != IPPROTO_UDP)
>>       1: (79) r2 = *(u64 *)(r1 +8)
>>       2: (69) r2 = *(u16 *)(r2 +924)
>>    ; if (half[0] != IPPROTO_UDP)
>>       3: (56) if w2 != 0x11 goto pc+4
>>    ; if (half[1] != 0)
>>       4: (b4) w1 = 0
>>       5: (b4) w0 = 1
>>    ; if (half[1] != 0)
>>       6: (16) if w1 == 0x0 goto pc+1
>>       7: (b4) w0 = 0
>>    ; }
>>       8: (95) exit
>>
>> Fixes: f96da09473b5 ("bpf: simplify narrower ctx access")
>> Suggested-by: Yonghong Song <yhs@fb.com>
>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>
> Thanks for the fix. The final code is much better now.
> Ack with some nits below.
>
> Acked-by: Yonghong Song <yhs@fb.com>
>
>> ---
>>   kernel/bpf/verifier.c | 23 +++++++++++++++++++++--
>>   1 file changed, 21 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index 94cead5a43e5..0a9dbcdd6341 100644
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@ -9614,11 +9614,11 @@ static int opt_subreg_zext_lo32_rnd_hi32(struct bpf_verifier_env *env,
>>    */
>>   static int convert_ctx_accesses(struct bpf_verifier_env *env)
>>   {
>> +	u32 target_size, size_default, off, access_off;
>>   	const struct bpf_verifier_ops *ops = env->ops;
>>   	int i, cnt, size, ctx_field_size, delta = 0;
>>   	const int insn_cnt = env->prog->len;
>>   	struct bpf_insn insn_buf[16], *insn;
>> -	u32 target_size, size_default, off;
>>   	struct bpf_prog *new_prog;
>>   	enum bpf_access_type type;
>>   	bool is_narrower_load;
>> @@ -9760,7 +9760,26 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
>>   			return -EINVAL;
>>   		}
>>   -		if (is_narrower_load && size < target_size) {
>> +		/* When context field is wider than the target field,
>> +		 * narrow load from an offset beyond the target field
>> +		 * can be reduced to loading zero because there is
>> +		 * nothing to load from memory.
>
> Maybe it is worthwhile to mention that the below codegen undos
> what convert_ctx_access() just did.
>
>> +		 */
>> +		access_off = off & (size_default - 1);
>> +		if (is_narrower_load && access_off >= target_size) {
>> +			cnt = 0;
>> +			if (ctx_field_size <= 4)
>> +				insn_buf[cnt++] = BPF_MOV32_IMM(insn->dst_reg, 0);
>> +			else
>> +				insn_buf[cnt++] = BPF_MOV64_IMM(insn->dst_reg, 0);
>> +		}
>> +		/* Narrow load from an offset within the target field,
>> +		 * smaller in size than the target field, needs
>> +		 * shifting and masking because convert_ctx_access
>> +		 * always emits full-size target field load.
>> +		 */
>> +		if (is_narrower_load && access_off < target_size &&
>> +		    size < target_size) {
>
> The code becomes a little bit complex here. I think it is worthwhile
> to have a static function to do codegen if is_narrower_load is true.
>
> The above two if statements are exclusive. It would be good to
> make it clear with "else if ...", and things will become easier
> if the narrower codegen is factored to a separate function.

Thanks for comments. I will circle back to it in a bit.

>
>>   			u8 shift = bpf_ctx_narrow_access_offset(
>>   				off, size, size_default) * 8;
>>   			if (ctx_field_size <= 4) {
>>


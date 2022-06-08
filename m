Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 826705432EA
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 16:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241892AbiFHOor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 10:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241911AbiFHOoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 10:44:25 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028F62AC6C;
        Wed,  8 Jun 2022 07:43:29 -0700 (PDT)
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nywtt-000AFv-88; Wed, 08 Jun 2022 16:43:13 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nywts-000K4B-W3; Wed, 08 Jun 2022 16:43:13 +0200
Subject: Re: [PATCH v2 1/3] bpf: Add bpf_verify_pkcs7_signature() helper
To:     Roberto Sassu <roberto.sassu@huawei.com>, ast@kernel.org,
        andrii@kernel.org, kpsingh@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        john.fastabend@gmail.com
References: <20220608111221.373833-1-roberto.sassu@huawei.com>
 <20220608111221.373833-2-roberto.sassu@huawei.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1456514b-ec2e-6a79-438a-33ad1ffc509d@iogearbox.net>
Date:   Wed, 8 Jun 2022 16:43:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220608111221.373833-2-roberto.sassu@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26566/Wed Jun  8 10:05:45 2022)
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/8/22 1:12 PM, Roberto Sassu wrote:
> Add the bpf_verify_pkcs7_signature() helper, to give the ability to eBPF
> security modules to check the validity of a PKCS#7 signature against
> supplied data.
> 
> Use the 'keyring' parameter to select the keyring containing the
> verification key: 0 for the primary keyring, 1 for the primary and
> secondary keyrings, 2 for the platform keyring.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> ---
>   include/uapi/linux/bpf.h       |  8 ++++++++
>   kernel/bpf/bpf_lsm.c           | 32 ++++++++++++++++++++++++++++++++
>   tools/include/uapi/linux/bpf.h |  8 ++++++++
>   3 files changed, 48 insertions(+)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index f4009dbdf62d..40d0fc0d9493 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -5249,6 +5249,13 @@ union bpf_attr {
>    *		Pointer to the underlying dynptr data, NULL if the dynptr is
>    *		read-only, if the dynptr is invalid, or if the offset and length
>    *		is out of bounds.
> + *
> + * long bpf_verify_pkcs7_signature(u8 *data, u32 datalen, u8 *sig, u32 siglen, u64 keyring)
> + *	Description
> + *		Verify the PKCS#7 *sig* with length *siglen*, on *data* with
> + *		length *datalen*, with key in *keyring*.

Could you also add a description for users about the keyring argument and guidance on when
they should use which in their programs? Above is a bit too terse, imho.

> + *	Return
> + *		0 on success, a negative value on error.
>    */
>   #define __BPF_FUNC_MAPPER(FN)		\
>   	FN(unspec),			\
> @@ -5455,6 +5462,7 @@ union bpf_attr {
>   	FN(dynptr_read),		\
>   	FN(dynptr_write),		\
>   	FN(dynptr_data),		\
> +	FN(verify_pkcs7_signature),	\
>   	/* */
>   
>   /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> index c1351df9f7ee..1cda43cb541a 100644
> --- a/kernel/bpf/bpf_lsm.c
> +++ b/kernel/bpf/bpf_lsm.c
> @@ -16,6 +16,7 @@
>   #include <linux/bpf_local_storage.h>
>   #include <linux/btf_ids.h>
>   #include <linux/ima.h>
> +#include <linux/verification.h>
>   
>   /* For every LSM hook that allows attachment of BPF programs, declare a nop
>    * function where a BPF program can be attached.
> @@ -132,6 +133,35 @@ static const struct bpf_func_proto bpf_get_attach_cookie_proto = {
>   	.arg1_type	= ARG_PTR_TO_CTX,
>   };
>   
> +BPF_CALL_5(bpf_verify_pkcs7_signature, u8 *, data, u32, datalen, u8 *, sig,
> +	   u32, siglen, u64, keyring)
> +{
> +	int ret = -EOPNOTSUPP;
> +
> +#ifdef CONFIG_SYSTEM_DATA_VERIFICATION
> +	if (keyring > (unsigned long)VERIFY_USE_PLATFORM_KEYRING)
> +		return -EINVAL;
> +
> +	ret = verify_pkcs7_signature(data, datalen, sig, siglen,
> +				     (struct key *)keyring,
> +				     VERIFYING_UNSPECIFIED_SIGNATURE, NULL,
> +				     NULL);
> +#endif
> +	return ret;
> +}

Looks great! One small nit, I would move all of the BPF_CALL and _proto under the
#ifdef CONFIG_SYSTEM_DATA_VERIFICATION ...

> +static const struct bpf_func_proto bpf_verify_pkcs7_signature_proto = {
> +	.func		= bpf_verify_pkcs7_signature,
> +	.gpl_only	= false,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type	= ARG_PTR_TO_MEM,
> +	.arg2_type	= ARG_CONST_SIZE_OR_ZERO,
> +	.arg3_type	= ARG_PTR_TO_MEM,
> +	.arg4_type	= ARG_CONST_SIZE_OR_ZERO,
> +	.arg5_type	= ARG_ANYTHING,
> +	.allowed	= bpf_ima_inode_hash_allowed,
> +};
> +
>   static const struct bpf_func_proto *
>   bpf_lsm_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>   {
> @@ -158,6 +188,8 @@ bpf_lsm_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>   		return prog->aux->sleepable ? &bpf_ima_file_hash_proto : NULL;
>   	case BPF_FUNC_get_attach_cookie:
>   		return bpf_prog_has_trampoline(prog) ? &bpf_get_attach_cookie_proto : NULL;
> +	case BPF_FUNC_verify_pkcs7_signature:
> +		return prog->aux->sleepable ? &bpf_verify_pkcs7_signature_proto : NULL;

... same here:

#ifdef CONFIG_SYSTEM_DATA_VERIFICATION
	case BPF_FUNC_verify_pkcs7_signature:
		return prog->aux->sleepable ? &bpf_verify_pkcs7_signature_proto : NULL;
#endif

So that bpftool or other feature probes can check for its availability. Otherwise, apps have
a hard time checking whether bpf_verify_pkcs7_signature() helper is available for use or not.

>   	default:
>   		return tracing_prog_func_proto(func_id, prog);
>   	}
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index f4009dbdf62d..40d0fc0d9493 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -5249,6 +5249,13 @@ union bpf_attr {
>    *		Pointer to the underlying dynptr data, NULL if the dynptr is
>    *		read-only, if the dynptr is invalid, or if the offset and length
>    *		is out of bounds.
> + *
> + * long bpf_verify_pkcs7_signature(u8 *data, u32 datalen, u8 *sig, u32 siglen, u64 keyring)
> + *	Description
> + *		Verify the PKCS#7 *sig* with length *siglen*, on *data* with
> + *		length *datalen*, with key in *keyring*.
> + *	Return
> + *		0 on success, a negative value on error.
>    */
>   #define __BPF_FUNC_MAPPER(FN)		\
>   	FN(unspec),			\
> @@ -5455,6 +5462,7 @@ union bpf_attr {
>   	FN(dynptr_read),		\
>   	FN(dynptr_write),		\
>   	FN(dynptr_data),		\
> +	FN(verify_pkcs7_signature),	\
>   	/* */
>   
>   /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> 


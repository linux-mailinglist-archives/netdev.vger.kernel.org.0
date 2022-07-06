Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86A88568E99
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 18:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233954AbiGFQEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 12:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233786AbiGFQEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 12:04:22 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D7A17586;
        Wed,  6 Jul 2022 09:04:20 -0700 (PDT)
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1o97VG-0003Og-IK; Wed, 06 Jul 2022 18:03:50 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1o97VG-000V92-4d; Wed, 06 Jul 2022 18:03:50 +0200
Subject: Re: [PATCH v6 4/5] bpf: Add bpf_verify_pkcs7_signature() helper
To:     Roberto Sassu <roberto.sassu@huawei.com>, ast@kernel.org,
        andrii@kernel.org, kpsingh@kernel.org, john.fastabend@gmail.com,
        songliubraving@fb.com, kafai@fb.com, yhs@fb.com,
        dhowells@redhat.com
Cc:     keyrings@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220628122750.1895107-1-roberto.sassu@huawei.com>
 <20220628122750.1895107-5-roberto.sassu@huawei.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <903b1b6c-b0fd-d624-a24b-5983d8d661b7@iogearbox.net>
Date:   Wed, 6 Jul 2022 18:03:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220628122750.1895107-5-roberto.sassu@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26595/Wed Jul  6 09:53:23 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/28/22 2:27 PM, Roberto Sassu wrote:
> Add the bpf_verify_pkcs7_signature() helper, to give eBPF security modules
> the ability to check the validity of a signature against supplied data, by
> using user-provided or system-provided keys as trust anchor.
> 
> The new helper makes it possible to enforce mandatory policies, as eBPF
> programs might be allowed to make security decisions only based on data
> sources the system administrator approves.
> 
> The caller should provide both the data to be verified and the signature as
> eBPF dynamic pointers (to minimize the number of parameters).
> 
> The caller should also provide a trusted keyring serial, together with key
> lookup-specific flags, to determine which keys can be used for signature
> verification. Alternatively, the caller could specify zero as serial value
> (not valid, serials must be positive), and provide instead a special
> keyring ID.
> 
> Key lookup flags are defined in include/linux/key.h and can be: 1, to
> request that special keyrings be created if referred to directly; 2 to
> permit partially constructed keys to be found.
> 
> Special IDs are defined in include/linux/verification.h and can be: 0 for
> the primary keyring (immutable keyring of system keys); 1 for both the
> primary and secondary keyring (where keys can be added only if they are
> vouched for by existing keys in those keyrings); 2 for the platform keyring
> (primarily used by the integrity subsystem to verify a kexec'ed kerned
> image and, possibly, the initramfs signature).
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> Reported-by: kernel test robot <lkp@intel.com> (cast warning)

nit: Given this a new feature not a fix to existing code, there is no need to
      add the above reported-by from kbuild bot.

> ---
>   include/uapi/linux/bpf.h       | 24 +++++++++++++
>   kernel/bpf/bpf_lsm.c           | 63 ++++++++++++++++++++++++++++++++++
>   tools/include/uapi/linux/bpf.h | 24 +++++++++++++
>   3 files changed, 111 insertions(+)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index e81362891596..b4f5ad863281 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -5325,6 +5325,29 @@ union bpf_attr {
>    *		**-EACCES** if the SYN cookie is not valid.
>    *
>    *		**-EPROTONOSUPPORT** if CONFIG_IPV6 is not builtin.
> + *
> + * long bpf_verify_pkcs7_signature(struct bpf_dynptr *data_ptr, struct bpf_dynptr *sig_ptr, u32 trusted_keyring_serial, unsigned long lookup_flags, unsigned long trusted_keyring_id)

nit: for the args instead of ulong, just do u64

> + *	Description
> + *		Verify the PKCS#7 signature *sig_ptr* against the supplied
> + *		*data_ptr* with keys in a keyring with serial
> + *		*trusted_keyring_serial*, searched with *lookup_flags*, if the
> + *		parameter value is positive, or alternatively in a keyring with
> + *		special ID *trusted_keyring_id* if *trusted_keyring_serial* is
> + *		zero.
> + *
> + *		*lookup_flags* are defined in include/linux/key.h and can be: 1,
> + *		to request that special keyrings be created if referred to
> + *		directly; 2 to permit partially constructed keys to be found.
> + *
> + *		Special IDs are defined in include/linux/verification.h and can
> + *		be: 0 for the primary keyring (immutable keyring of system
> + *		keys); 1 for both the primary and secondary keyring (where keys
> + *		can be added only if they are vouched for by existing keys in
> + *		those keyrings); 2 for the platform keyring (primarily used by
> + *		the integrity subsystem to verify a kexec'ed kerned image and,
> + *		possibly, the initramfs signature).
> + *	Return
> + *		0 on success, a negative value on error.
>    */
>   #define __BPF_FUNC_MAPPER(FN)		\
>   	FN(unspec),			\
> @@ -5535,6 +5558,7 @@ union bpf_attr {
>   	FN(tcp_raw_gen_syncookie_ipv6),	\
>   	FN(tcp_raw_check_syncookie_ipv4),	\
>   	FN(tcp_raw_check_syncookie_ipv6),	\
> +	FN(verify_pkcs7_signature),	\

(Needs rebase)

>   	/* */
>   
>   /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> index c1351df9f7ee..401bda01ad84 100644
> --- a/kernel/bpf/bpf_lsm.c
> +++ b/kernel/bpf/bpf_lsm.c
> @@ -16,6 +16,8 @@
>   #include <linux/bpf_local_storage.h>
>   #include <linux/btf_ids.h>
>   #include <linux/ima.h>
> +#include <linux/verification.h>
> +#include <linux/key.h>
>   
>   /* For every LSM hook that allows attachment of BPF programs, declare a nop
>    * function where a BPF program can be attached.
> @@ -132,6 +134,62 @@ static const struct bpf_func_proto bpf_get_attach_cookie_proto = {
>   	.arg1_type	= ARG_PTR_TO_CTX,
>   };
>   
> +#ifdef CONFIG_SYSTEM_DATA_VERIFICATION
> +BPF_CALL_5(bpf_verify_pkcs7_signature, struct bpf_dynptr_kern *, data_ptr,
> +	   struct bpf_dynptr_kern *, sig_ptr, u32, trusted_keyring_serial,
> +	   unsigned long, lookup_flags, unsigned long, trusted_keyring_id)
> +{
> +	key_ref_t trusted_keyring_ref;
> +	struct key *trusted_keyring;
> +	int ret;
> +
> +	/* Keep in sync with defs in include/linux/key.h. */
> +	if (lookup_flags > KEY_LOOKUP_PARTIAL)
> +		return -EINVAL;

iiuc, the KEY_LOOKUP_* is a mask, so you could also combine the two, e.g.
KEY_LOOKUP_CREATE | KEY_LOOKUP_PARTIAL. I haven't seen you mentioning anything
specific on why it is not allowed. What's the rationale, if it's intentional
if should probably be documented?

At minimum I also think the helper description needs to be improved for people
to understand enough w/o reading through the kernel source, e.g. wrt lookup_flags
since I haven't seen it in your selftests either ... when does a user need to
use the given flags.

nit: when both trusted_keyring_serial and trusted_keyring_id are passed to the
helper, then this should be rejected as invalid argument? (Kind of feels a bit
like we're cramming two things in one helper.. KP, thoughts? :))

> +	/* Keep in sync with defs in include/linux/verification.h. */
> +	if (trusted_keyring_id > (unsigned long)VERIFY_USE_PLATFORM_KEYRING)
> +		return -EINVAL;
> +
> +	if (trusted_keyring_serial) {
> +		trusted_keyring_ref = lookup_user_key(trusted_keyring_serial,
> +						      lookup_flags,
> +						      KEY_NEED_SEARCH);
> +		if (IS_ERR(trusted_keyring_ref))
> +			return PTR_ERR(trusted_keyring_ref);
> +
> +		trusted_keyring = key_ref_to_ptr(trusted_keyring_ref);
> +		goto verify;
> +	}
> +
> +	trusted_keyring = (struct key *)trusted_keyring_id;
> +verify:
> +	ret = verify_pkcs7_signature(data_ptr->data,
> +				     bpf_dynptr_get_size(data_ptr),
> +				     sig_ptr->data,
> +				     bpf_dynptr_get_size(sig_ptr),
> +				     trusted_keyring,
> +				     VERIFYING_UNSPECIFIED_SIGNATURE, NULL,
> +				     NULL);
> +	if (trusted_keyring_serial)
> +		key_put(trusted_keyring);
> +
> +	return ret;
> +}
> +
> +static const struct bpf_func_proto bpf_verify_pkcs7_signature_proto = {
> +	.func		= bpf_verify_pkcs7_signature,
> +	.gpl_only	= false,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type	= ARG_PTR_TO_DYNPTR | DYNPTR_TYPE_LOCAL,
> +	.arg2_type	= ARG_PTR_TO_DYNPTR | DYNPTR_TYPE_LOCAL,
> +	.arg3_type	= ARG_ANYTHING,
> +	.arg4_type	= ARG_ANYTHING,
> +	.arg5_type	= ARG_ANYTHING,
> +	.allowed	= bpf_ima_inode_hash_allowed,
> +};
> +#endif /* CONFIG_SYSTEM_DATA_VERIFICATION */
> +

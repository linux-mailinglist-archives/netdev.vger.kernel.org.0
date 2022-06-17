Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3B254F3F9
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 11:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380897AbiFQJLY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 17 Jun 2022 05:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234893AbiFQJLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 05:11:22 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC19F5640F;
        Fri, 17 Jun 2022 02:11:19 -0700 (PDT)
Received: from fraeml710-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LPYDn718dz687wq;
        Fri, 17 Jun 2022 17:11:05 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml710-chm.china.huawei.com (10.206.15.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 17 Jun 2022 11:11:17 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2375.024;
 Fri, 17 Jun 2022 11:11:17 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "kafai@fb.com" <kafai@fb.com>, "yhs@fb.com" <yhs@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "dhowells@redhat.com" <dhowells@redhat.com>
Subject: RE: [RESEND][PATCH v4 2/4] bpf: Add bpf_request_key_by_id() helper
Thread-Topic: [RESEND][PATCH v4 2/4] bpf: Add bpf_request_key_by_id() helper
Thread-Index: AQHYf++U6MIlvDYsd0yY3m2zPy+uQa1S2DKAgABsoGA=
Date:   Fri, 17 Jun 2022 09:11:17 +0000
Message-ID: <b146ee9242cb4c128e56bc9cb3b20b26@huawei.com>
References: <20220614130621.1976089-1-roberto.sassu@huawei.com>
 <20220614130621.1976089-3-roberto.sassu@huawei.com>
 <20220617034617.db23phfavuhqx4vi@MacBook-Pro-3.local>
In-Reply-To: <20220617034617.db23phfavuhqx4vi@MacBook-Pro-3.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.81.221.51]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Sent: Friday, June 17, 2022 5:46 AM

Adding in CC the keyring mailing list and David.

Sort summary: we are adding an eBPF helper, to let eBPF programs
verify PKCS#7 signatures. The helper simply calls verify_pkcs7_signature().

The problem is how to pass the key for verification.

For hardcoded keyring IDs, it is easy, pass 0, 1 or 2 for respectively
the built-in, secondary and platform keyring.

If you want to pass another keyring, you need to do a lookup,
which returns a key with reference count increased.

While in the kernel you can call key_put() to decrease the
reference count, that is not guaranteed with an eBPF program,
if the developer forgets about it. What probably is necessary,
is to add the capability to the verifier to check whether the
reference count is decreased, or adding a callback mechanism
to call automatically key_put() when the eBPF program is
terminated.

Is there an alternative solution?

Thanks

Roberto

HUAWEI TECHNOLOGIES Duesseldorf GmbH,
HRB 56063 Managing Director: Li Peng, Yang Xi, Li He

> On Tue, Jun 14, 2022 at 03:06:19PM +0200, Roberto Sassu wrote:
> > Add the bpf_request_key_by_id() helper, so that an eBPF program can
> > obtain a suitable key pointer to pass to the
> > bpf_verify_pkcs7_signature() helper, to be introduced in a later patch.
> >
> > The passed identifier can have the following values: 0 for the primary
> > keyring (immutable keyring of system keys); 1 for both the primary and
> > secondary keyring (where keys can be added only if they are vouched
> > for by existing keys in those keyrings); 2 for the platform keyring
> > (primarily used by the integrity subsystem to verify a kexec'ed kerned
> > image and, possibly, the initramfs signature); ULONG_MAX for the
> > session keyring (for testing purposes).
> >
> > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > ---
> >  include/uapi/linux/bpf.h       | 17 +++++++++++++++++
> >  kernel/bpf/bpf_lsm.c           | 30 ++++++++++++++++++++++++++++++
> >  scripts/bpf_doc.py             |  2 ++
> >  tools/include/uapi/linux/bpf.h | 17 +++++++++++++++++
> >  4 files changed, 66 insertions(+)
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h index
> > f4009dbdf62d..dfd93e0e0759 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -5249,6 +5249,22 @@ union bpf_attr {
> >   *		Pointer to the underlying dynptr data, NULL if the dynptr is
> >   *		read-only, if the dynptr is invalid, or if the offset and length
> >   *		is out of bounds.
> > + *
> > + * struct key *bpf_request_key_by_id(unsigned long id)
> > + *	Description
> > + *		Request a keyring by *id*.
> > + *
> > + *		*id* can have the following values (some defined in
> > + *		verification.h): 0 for the primary keyring (immutable keyring
> of
> > + *		system keys); 1 for both the primary and secondary keyring
> > + *		(where keys can be added only if they are vouched for by
> > + *		existing keys in those keyrings); 2 for the platform keyring
> > + *		(primarily used by the integrity subsystem to verify a
> kexec'ed
> > + *		kerned image and, possibly, the initramfs signature);
> ULONG_MAX
> > + *		for the session keyring (for testing purposes).
> 
> It's never ok to add something like this to uapi 'for testing purposes'.
> If it's not useful in general it should not be a part of api.
> 
> > + *	Return
> > + *		A non-NULL pointer if *id* is valid and not 0, a NULL pointer
> > + *		otherwise.
> >   */
> >  #define __BPF_FUNC_MAPPER(FN)		\
> >  	FN(unspec),			\
> > @@ -5455,6 +5471,7 @@ union bpf_attr {
> >  	FN(dynptr_read),		\
> >  	FN(dynptr_write),		\
> >  	FN(dynptr_data),		\
> > +	FN(request_key_by_id),		\
> >  	/* */
> >
> >  /* integer value in 'imm' field of BPF_CALL instruction selects which
> > helper diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c index
> > c1351df9f7ee..e1911812398b 100644
> > --- a/kernel/bpf/bpf_lsm.c
> > +++ b/kernel/bpf/bpf_lsm.c
> > @@ -16,6 +16,7 @@
> >  #include <linux/bpf_local_storage.h>
> >  #include <linux/btf_ids.h>
> >  #include <linux/ima.h>
> > +#include <linux/verification.h>
> >
> >  /* For every LSM hook that allows attachment of BPF programs, declare a
> nop
> >   * function where a BPF program can be attached.
> > @@ -132,6 +133,31 @@ static const struct bpf_func_proto
> bpf_get_attach_cookie_proto = {
> >  	.arg1_type	= ARG_PTR_TO_CTX,
> >  };
> >
> > +#ifdef CONFIG_KEYS
> > +BTF_ID_LIST_SINGLE(bpf_request_key_by_id_btf_ids, struct, key)
> > +
> > +BPF_CALL_1(bpf_request_key_by_id, unsigned long, id) {
> > +	const struct cred *cred = current_cred();
> > +
> > +	if (id > (unsigned long)VERIFY_USE_PLATFORM_KEYRING && id !=
> ULONG_MAX)
> > +		return (unsigned long)NULL;
> > +
> > +	if (id == ULONG_MAX)
> > +		return (unsigned long)cred->session_keyring;
> > +
> > +	return id;
> 
> It needs to do a proper lookup.
> Why cannot it do lookup_user_key ?
> The helper needs 'flags' arg too.
> Please think hard of extensibility and long term usefulness of api.
> At present this api feels like it was 'let me just hack something quickly'. Not
> ok.

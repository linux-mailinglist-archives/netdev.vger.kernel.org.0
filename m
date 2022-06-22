Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4307355442B
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 10:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352265AbiFVHMI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 22 Jun 2022 03:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352211AbiFVHMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 03:12:05 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA5636B74;
        Wed, 22 Jun 2022 00:12:04 -0700 (PDT)
Received: from fraeml715-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LSZGf4P0Zz67wrR;
        Wed, 22 Jun 2022 15:08:10 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml715-chm.china.huawei.com (10.206.15.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 22 Jun 2022 09:12:02 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2375.024;
 Wed, 22 Jun 2022 09:12:02 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "kafai@fb.com" <kafai@fb.com>, "yhs@fb.com" <yhs@fb.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v5 2/5] bpf: Add bpf_lookup_user_key() and bpf_key_put()
 helpers
Thread-Topic: [PATCH v5 2/5] bpf: Add bpf_lookup_user_key() and bpf_key_put()
 helpers
Thread-Index: AQHYhY1k21fgeQJHrk6eeuiL0ORSsa1aUQkAgACxApA=
Date:   Wed, 22 Jun 2022 07:12:02 +0000
Message-ID: <796b55c79be142cab6a22dd281fdb9fa@huawei.com>
References: <20220621163757.760304-1-roberto.sassu@huawei.com>
 <20220621163757.760304-3-roberto.sassu@huawei.com>
 <20220621223248.f6wgyewajw6x4lgr@macbook-pro-3.dhcp.thefacebook.com>
In-Reply-To: <20220621223248.f6wgyewajw6x4lgr@macbook-pro-3.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.221.98.153]
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

> From: Alexei Starovoitov [mailto:alexei.starovoitov@gmail.com]
> Sent: Wednesday, June 22, 2022 12:33 AM
> On Tue, Jun 21, 2022 at 06:37:54PM +0200, Roberto Sassu wrote:
> > Add the bpf_lookup_user_key() and bpf_key_put() helpers, to respectively
> > search a key with a given serial, and release the reference count of the
> > found key.
> >
> > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > ---
> >  include/uapi/linux/bpf.h       | 16 ++++++++++++
> >  kernel/bpf/bpf_lsm.c           | 46 ++++++++++++++++++++++++++++++++++
> >  kernel/bpf/verifier.c          |  6 +++--
> >  scripts/bpf_doc.py             |  2 ++
> >  tools/include/uapi/linux/bpf.h | 16 ++++++++++++
> >  5 files changed, 84 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index e81362891596..7bbcf2cd105d 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -5325,6 +5325,20 @@ union bpf_attr {
> >   *		**-EACCES** if the SYN cookie is not valid.
> >   *
> >   *		**-EPROTONOSUPPORT** if CONFIG_IPV6 is not builtin.
> > + *
> > + * struct key *bpf_lookup_user_key(u32 serial, unsigned long flags)
> > + *	Description
> > + *		Search a key with a given *serial* and the provided *flags*, and
> > + *		increment the reference count of the key.
> 
> Why passing 'flags' is ok to do?
> Please think through every line of the patch.

To be honest, I thought about it. Probably yes, I should do some
sanitization, like I did for the keyring ID. When I checked
lookup_user_key(), I saw that flags are checked individually, so
an arbitrary value passed to the helper should not cause harm.
Will do sanitization, if you prefer. It is just that we have to keep
the eBPF code in sync with key flag definition (unless we have
a 'last' flag).

Thanks

Roberto

HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Li Peng, Yang Xi, Li He

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCE75543EE
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 10:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349153AbiFVHGR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 22 Jun 2022 03:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbiFVHGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 03:06:16 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 150A936B47;
        Wed, 22 Jun 2022 00:06:15 -0700 (PDT)
Received: from fraeml710-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LSZB70KnBz67mnw;
        Wed, 22 Jun 2022 15:04:15 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml710-chm.china.huawei.com (10.206.15.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 22 Jun 2022 09:06:12 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2375.024;
 Wed, 22 Jun 2022 09:06:12 +0200
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
Subject: RE: [PATCH v5 5/5] selftests/bpf: Add test for
 bpf_verify_pkcs7_signature() helper
Thread-Topic: [PATCH v5 5/5] selftests/bpf: Add test for
 bpf_verify_pkcs7_signature() helper
Thread-Index: AQHYhY2R+7oGNnsbDU2QqyKkP3n2X61aULGAgACwS9A=
Date:   Wed, 22 Jun 2022 07:06:12 +0000
Message-ID: <76c319d5ad1e4ac69ae5d3f71e9d62f7@huawei.com>
References: <20220621163757.760304-1-roberto.sassu@huawei.com>
 <20220621163757.760304-6-roberto.sassu@huawei.com>
 <20220621223135.puwe3m55yznaevm5@macbook-pro-3.dhcp.thefacebook.com>
In-Reply-To: <20220621223135.puwe3m55yznaevm5@macbook-pro-3.dhcp.thefacebook.com>
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
> Sent: Wednesday, June 22, 2022 12:32 AM
> On Tue, Jun 21, 2022 at 06:37:57PM +0200, Roberto Sassu wrote:
> > +	if (child_pid == 0) {
> > +		snprintf(path, sizeof(path), "%s/signing_key.pem", tmp_dir);
> > +
> > +		return execlp("./sign-file", "./sign-file", "-d", "sha256",
> > +			      path, path, data_template, NULL);
> 
> Did you miss my earlier reply requesting not to do this module_signature append
> and use signature directly?

I didn't miss. sign-file is producing the raw PKCS#7 signature here (-d).

I'm doing something slightly different, to test the keyring ID part.
I'm retrieving an existing kernel module (actually this does not work
in the CI), parsing it to extract the raw signature, and passing it to the
eBPF program for verification.

Since the kernel module is signed with a key in the built-in keyring,
passing 1 or 0 as ID should work.

Roberto

(sorry, I have to keep the email signature by German law)

HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Li Peng, Yang Xi, Li He

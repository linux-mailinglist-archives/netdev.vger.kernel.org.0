Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6DBE4C404C
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 09:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238586AbiBYImE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 25 Feb 2022 03:42:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbiBYImC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 03:42:02 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B7E253145;
        Fri, 25 Feb 2022 00:41:27 -0800 (PST)
Received: from fraeml709-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K4jsD5X8Kz67yxx;
        Fri, 25 Feb 2022 16:40:32 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml709-chm.china.huawei.com (10.206.15.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 25 Feb 2022 09:41:25 +0100
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2308.021;
 Fri, 25 Feb 2022 09:41:25 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Mimi Zohar <zohar@linux.ibm.com>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "revest@chromium.org" <revest@chromium.org>
CC:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 0/6] bpf-lsm: Extend interoperability with IMA
Thread-Topic: [PATCH v2 0/6] bpf-lsm: Extend interoperability with IMA
Thread-Index: AQHYImlgJM6Z1962JUm5hvc+dgM0dqyjZeaAgACU/jA=
Date:   Fri, 25 Feb 2022 08:41:25 +0000
Message-ID: <5117c79227ce4b9d97e193fd8fb59ba2@huawei.com>
References: <20220215124042.186506-1-roberto.sassu@huawei.com>
 <408a96085814b2578486b2859e63ff906f5e5876.camel@linux.ibm.com>
In-Reply-To: <408a96085814b2578486b2859e63ff906f5e5876.camel@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.204.63.33]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Mimi Zohar [mailto:zohar@linux.ibm.com]
> Sent: Friday, February 25, 2022 1:22 AM
> Hi Roberto,
> 
> On Tue, 2022-02-15 at 13:40 +0100, Roberto Sassu wrote:
> > Extend the interoperability with IMA, to give wider flexibility for the
> > implementation of integrity-focused LSMs based on eBPF.
> 
> I've previously requested adding eBPF module measurements and signature
> verification support in IMA.  There seemed to be some interest, but
> nothing has been posted.

Hi Mimi

for my use case, DIGLIM eBPF, IMA integrity verification is
needed until the binary carrying the eBPF program is executed
as the init process. I've been thinking to use an appended
signature to overcome the limitation of lack of xattrs in the
initial ram disk.

At that point, the LSM is attached and it can enforce an
execution policy, allowing or denying execution and mmap
of files depending on the digest lists (reference values) read
by the user space side.

After the LSM is attached, IMA's job would be just to calculate
the file digests (currently, I'm using an audit policy to ensure
that the digest is available when the eBPF program calls
bpf_ima_inode_hash()).

The main benefit of this patch set is that the audit policy
would not be required and digests are calculated only when
requested by the eBPF program.

Thanks

Roberto

HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Li Peng, Zhong Ronghua

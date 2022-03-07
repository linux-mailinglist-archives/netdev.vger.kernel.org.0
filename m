Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1F6A4CFC51
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 12:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241959AbiCGLJm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 7 Mar 2022 06:09:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241559AbiCGLJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 06:09:18 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2DA173064;
        Mon,  7 Mar 2022 02:31:54 -0800 (PST)
Received: from fraeml711-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KBvqS3Rl4z67bhp;
        Mon,  7 Mar 2022 18:30:28 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml711-chm.china.huawei.com (10.206.15.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 7 Mar 2022 11:31:52 +0100
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2308.021;
 Mon, 7 Mar 2022 11:31:52 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Mimi Zohar <zohar@linux.ibm.com>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>, "yhs@fb.com" <yhs@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "revest@chromium.org" <revest@chromium.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 0/9] bpf-lsm: Extend interoperability with IMA
Thread-Topic: [PATCH v3 0/9] bpf-lsm: Extend interoperability with IMA
Thread-Index: AQHYLiawVJiGIoJTAUWtCyWVLc4li6yyskqAgAEMPpA=
Date:   Mon, 7 Mar 2022 10:31:52 +0000
Message-ID: <54a2b65856e4439f9170dfd86bbeb975@huawei.com>
References: <20220302111404.193900-1-roberto.sassu@huawei.com>
 <9be81980b1849dc60b46ad0672b667b6b5365f2d.camel@linux.ibm.com>
In-Reply-To: <9be81980b1849dc60b46ad0672b667b6b5365f2d.camel@linux.ibm.com>
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
> Sent: Sunday, March 6, 2022 8:24 PM
> On Wed, 2022-03-02 at 12:13 +0100, Roberto Sassu wrote:
> > Extend the interoperability with IMA, to give wider flexibility for the
> > implementation of integrity-focused LSMs based on eBPF.
> >
> > Patch 1 fixes some style issues.
> >
> > Patches 2-6 give the ability to eBPF-based LSMs to take advantage of the
> > measurement capability of IMA without needing to setup a policy in IMA
> > (those LSMs might implement the policy capability themselves).
> >
> > Patches 7-9 allow eBPF-based LSMs to evaluate files read by the kernel.
> 
> The tests seem to only work when neither a builtin IMA policy or a
> custom policy is previously loaded.

Hi Mimi

unfortunately yes. If there are more generic rules,
the number of samples differs from that expected.

For example, if you have an existing rule like:

measure func=BPRM_CHECK mask=MAY_EXEC

you will have:

test_test_ima:PASS:run_measured_process #1 0 nsec
test_test_ima:FAIL:num_samples_or_err unexpected
                num_samples_or_err: actual 2 != expected 1

Test #1 fails because also ima_setup.sh is measured.

Thanks

Roberto

HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Li Peng, Zhong Ronghua

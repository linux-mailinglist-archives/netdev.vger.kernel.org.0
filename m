Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAC094B2691
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 13:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350375AbiBKM6B convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 11 Feb 2022 07:58:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349140AbiBKM54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 07:57:56 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8DCF1C0;
        Fri, 11 Feb 2022 04:57:54 -0800 (PST)
Received: from fraeml711-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JwDDQ5zv0z686th;
        Fri, 11 Feb 2022 20:57:42 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml711-chm.china.huawei.com (10.206.15.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 11 Feb 2022 13:57:52 +0100
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2308.021;
 Fri, 11 Feb 2022 13:57:52 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Mimi Zohar <zohar@linux.ibm.com>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>
CC:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Florent Revest <revest@google.com>
Subject: RE: [PATCH] ima: Calculate digest in ima_inode_hash() if not
 available
Thread-Topic: [PATCH] ima: Calculate digest in ima_inode_hash() if not
 available
Thread-Index: AQHYHzTu9kKzqhEAHUiW0cSG9MzvPayOOgmAgAAS5hA=
Date:   Fri, 11 Feb 2022 12:57:52 +0000
Message-ID: <3d0bdb4599e340a78b06094797e42bc9@huawei.com>
References: <20220211104828.4061334-1-roberto.sassu@huawei.com>
 <f9ccc9be6cc084e9cab6cd75e87735492d120002.camel@linux.ibm.com>
In-Reply-To: <f9ccc9be6cc084e9cab6cd75e87735492d120002.camel@linux.ibm.com>
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
> Sent: Friday, February 11, 2022 1:41 PM
> Hi Roberto,
> 
> On Fri, 2022-02-11 at 11:48 +0100, Roberto Sassu wrote:
> > __ima_inode_hash() checks if a digest has been already calculated by
> > looking for the integrity_iint_cache structure associated to the passed
> > inode.
> >
> > Users of ima_file_hash() and ima_inode_hash() (e.g. eBPF) might be
> > interested in obtaining the information without having to setup an IMA
> > policy so that the digest is always available at the time they call one of
> > those functions.
> 
> Things obviously changed, but the original use case for this interface,
> as I recall, was a quick way to determine if a file had been accessed
> on the system.

Hi Mimi

thanks for the info. I was not sure if I should export a new
function or reuse the existing one. In my use case, just calculating
the digest would be sufficient.

For finding whether a file was accessed (assuming that it matches
the policy), probably bpf_ima_inode_hash() is not anyway too reliable.
If integrity_iint_cache is evicted from the memory, it would report
that the inode was not accessed even if it was.

Thanks

Roberto

HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Li Peng, Zhong Ronghua

> --
> thanks,
> 
> Mimi


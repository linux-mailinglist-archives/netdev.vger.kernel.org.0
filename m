Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C61E4B64EE
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 09:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235045AbiBOIAx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 15 Feb 2022 03:00:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235011AbiBOIAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 03:00:48 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DBF313E1B;
        Tue, 15 Feb 2022 00:00:38 -0800 (PST)
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JyYLg2SbYz67ts3;
        Tue, 15 Feb 2022 15:56:11 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Feb 2022 09:00:35 +0100
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2308.021;
 Tue, 15 Feb 2022 09:00:35 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Mimi Zohar <zohar@linux.ibm.com>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        Florent Revest <revest@chromium.org>
CC:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] ima: Calculate digest in ima_inode_hash() if not
 available
Thread-Topic: [PATCH] ima: Calculate digest in ima_inode_hash() if not
 available
Thread-Index: AQHYHzTu9kKzqhEAHUiW0cSG9MzvPayRZbiAgAHZaqCAAFdHgIAArm+A
Date:   Tue, 15 Feb 2022 08:00:34 +0000
Message-ID: <311b5d0b3b824c548a4032a76a408944@huawei.com>
References: <20220211104828.4061334-1-roberto.sassu@huawei.com>
         <537635732d9cbcc42bcf7be5ed932d284b03d39f.camel@linux.ibm.com>
         <cc6bcb7742dc432ba990ee38b5909496@huawei.com>
 <36f85113f181f78eda3576823bd92be3f9cd1802.camel@linux.ibm.com>
In-Reply-To: <36f85113f181f78eda3576823bd92be3f9cd1802.camel@linux.ibm.com>
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
> Sent: Monday, February 14, 2022 11:33 PM
> On Mon, 2022-02-14 at 17:05 +0000, Roberto Sassu wrote:
> > > From: Mimi Zohar [mailto:zohar@linux.ibm.com]
> > > Sent: Sunday, February 13, 2022 2:06 PM
> > > Hi Roberto,
> > >
> > > On Fri, 2022-02-11 at 11:48 +0100, Roberto Sassu wrote:
> > > > __ima_inode_hash() checks if a digest has been already calculated by
> > > > looking for the integrity_iint_cache structure associated to the passed
> > > > inode.
> > > >
> > > > Users of ima_file_hash() and ima_inode_hash() (e.g. eBPF) might be
> > > > interested in obtaining the information without having to setup an IMA
> > > > policy so that the digest is always available at the time they call one of
> > > > those functions.
> > > >
> > > > Open a new file descriptor in __ima_inode_hash(), so that this function
> > > > could invoke ima_collect_measurement() to calculate the digest if it is not
> > > > available. Still return -EOPNOTSUPP if the calculation failed.
> > > >
> > > > Instead of opening a new file descriptor, the one from ima_file_hash()
> > > > could have been used. However, since ima_inode_hash() was created to
> > > obtain
> > > > the digest when the file descriptor is not available, it could benefit from
> > > > this change too. Also, the opened file descriptor might be not suitable for
> > > > use (file descriptor opened not for reading).
> > > >
> > > > This change does not cause memory usage increase, due to using a
> temporary
> > > > integrity_iint_cache structure for the digest calculation, and due to
> > > > freeing the ima_digest_data structure inside integrity_iint_cache before
> > > > exiting from __ima_inode_hash().
> > > >
> > > > Finally, update the test by removing ima_setup.sh (it is not necessary
> > > > anymore to set an IMA policy) and by directly executing /bin/true.
> > > >
> > > > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > >
> > > Although this patch doesn't directly modify either ima_file_hash() or
> > > ima_inode_hash(),  this change affects both functions.  ima_file_hash()
> > > was introduced to be used with eBPF.  Based on Florent's post, changing
> > > the ima_file_hash() behavor seems fine.  Since I have no idea whether
> > > anyone is still using ima_inode_hash(), perhaps it would be safer to
> > > limit this behavior change to just ima_file_hash().
> >
> > Hi Mimi
> >
> > ok.
> >
> > I found that just checking that iint->ima_hash is not NULL is not enough
> > (ima_inode_hash() might still return the old digest after a file write).
> > Should I replace that check with !(iint->flags & IMA_COLLECTED)?
> > Or should I do only for ima_file_hash() and recalculate the digest
> > if necessary?
> 
> Updating the file hash after each write would really impact IMA
> performance.  If you really want to detect any file change, no matter
> how frequently it occurs, your best bet would be to track i_generation
> and i_version.  Stefan is already adding "i_generation" for IMA
> namespacing.

I just wanted the ability to get a fresh digest after a file opened
for writing is closed. Since in my use case I would not use an IMA
policy, that would not be a problem.

Thanks

Roberto

HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Li Peng, Zhong Ronghua

> > > Please update the ima_file_hash() doc.  While touching this area, I'd
> > > appreciate your fixing the first doc line in both ima_file_hash() and
> > > ima_inode_hash() cases, which wraps spanning two lines.
> >
> > Did you mean to make the description shorter or to have everything
> > in one line? According to the kernel documentation (kernel-doc.rst),
> > having the brief description in multiple lines should be fine.
> 
> Thanks for checking kernel-doc.   The "brief description"  not wrapping
> across multiple lines did in fact change.
> 
> > > Please split the IMA from the eBPF changes.
> >
> > Ok.
> 
> --
> thanks,
> 
> Mimi


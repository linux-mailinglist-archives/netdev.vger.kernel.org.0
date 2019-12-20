Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99842128263
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 19:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727552AbfLTSs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 13:48:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:43514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727394AbfLTSs1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Dec 2019 13:48:27 -0500
Received: from localhost (unknown [5.29.147.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D0FC20866;
        Fri, 20 Dec 2019 18:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576867705;
        bh=9uwZwW8nPS+75031v8hDGC7HtDf+0EIn7DmGn/ZPhLI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LWTpeDghlapT7e9QeowMyEsKots1GGKoA5cxDBWPKxcsMa8afpvj3TIhg42NfecMr
         n4GpE+h71j//kE94YhR/cIu0AoNi6vRxas1Bt4JmzW5rS36c/LVw4EGx6UtAXWnHfJ
         xwyw4vcYCuXeNv4Wj/Dw3P5l12jwtULyC7zQzCys=
Date:   Fri, 20 Dec 2019 20:48:21 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Shuah Khan <shuah@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, bpf@vger.kernel.org,
        dri-devel@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-media@vger.kernel.org, linux-rdma@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>
Subject: Re: [PATCH v11 00/25] mm/gup: track dma-pinned pages: FOLL_PIN
Message-ID: <20191220184821.GB10944@unreal>
References: <20191216222537.491123-1-jhubbard@nvidia.com>
 <20191219132607.GA410823@unreal>
 <a4849322-8e17-119e-a664-80d9f95d850b@nvidia.com>
 <20191219210743.GN17227@ziepe.ca>
 <f10b2a18-a109-d87d-f156-2e5941cbf4a0@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f10b2a18-a109-d87d-f156-2e5941cbf4a0@nvidia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 02:58:43PM -0800, John Hubbard wrote:
> On 12/19/19 1:07 PM, Jason Gunthorpe wrote:
> ...
> > > 3. It would be nice if I could reproduce this. I have a two-node mlx5 Infiniband
> > > test setup, but I have done only the tiniest bit of user space IB coding, so
> > > if you have any test programs that aren't too hard to deal with that could
> > > possibly hit this, or be tweaked to hit it, I'd be grateful. Keeping in mind
> > > that I'm not an advanced IB programmer. At all. :)
> >
> > Clone this:
> >
> > https://github.com/linux-rdma/rdma-core.git
> >
> > Install all the required deps to build it (notably cython), see the README.md
> >
> > $ ./build.sh
> > $ build/bin/run_tests.py
> >
> > If you get things that far I think Leon can get a reproduction for you
> >
>
> Cool, it's up and running (1 failure, 3 skipped, out of 67 tests).
>
> This is a great test suite to have running, I'll add it to my scripts. Here's the
> full output in case the failure or skip cases are a problem:
>
> $ sudo ./build/bin/run_tests.py --verbose
>
> test_create_ah (tests.test_addr.AHTest) ... ok
> test_create_ah_roce (tests.test_addr.AHTest) ... skipped "Can't run RoCE tests on IB link layer"
> test_destroy_ah (tests.test_addr.AHTest) ... ok
> test_create_comp_channel (tests.test_cq.CCTest) ... ok
> test_destroy_comp_channel (tests.test_cq.CCTest) ... ok
> test_create_cq_ex (tests.test_cq.CQEXTest) ... ok
> test_create_cq_ex_bad_flow (tests.test_cq.CQEXTest) ... ok
> test_destroy_cq_ex (tests.test_cq.CQEXTest) ... ok
> test_create_cq (tests.test_cq.CQTest) ... ok
> test_create_cq_bad_flow (tests.test_cq.CQTest) ... ok
> test_destroy_cq (tests.test_cq.CQTest) ... ok
> test_rc_traffic_cq_ex (tests.test_cqex.CqExTestCase) ... ok
> test_ud_traffic_cq_ex (tests.test_cqex.CqExTestCase) ... ok
> test_xrc_traffic_cq_ex (tests.test_cqex.CqExTestCase) ... ok
> test_create_dm (tests.test_device.DMTest) ... ok
> test_create_dm_bad_flow (tests.test_device.DMTest) ... ok
> test_destroy_dm (tests.test_device.DMTest) ... ok
> test_destroy_dm_bad_flow (tests.test_device.DMTest) ... ok
> test_dm_read (tests.test_device.DMTest) ... ok
> test_dm_write (tests.test_device.DMTest) ... ok
> test_dm_write_bad_flow (tests.test_device.DMTest) ... ok
> test_dev_list (tests.test_device.DeviceTest) ... ok
> test_open_dev (tests.test_device.DeviceTest) ... ok
> test_query_device (tests.test_device.DeviceTest) ... ok
> test_query_device_ex (tests.test_device.DeviceTest) ... ok
> test_query_gid (tests.test_device.DeviceTest) ... ok
> test_query_port (tests.test_device.DeviceTest) ... FAIL
> test_query_port_bad_flow (tests.test_device.DeviceTest) ... ok
> test_create_dm_mr (tests.test_mr.DMMRTest) ... ok
> test_destroy_dm_mr (tests.test_mr.DMMRTest) ... ok
> test_buffer (tests.test_mr.MRTest) ... ok
> test_dereg_mr (tests.test_mr.MRTest) ... ok
> test_dereg_mr_twice (tests.test_mr.MRTest) ... ok
> test_lkey (tests.test_mr.MRTest) ... ok
> test_read (tests.test_mr.MRTest) ... ok
> test_reg_mr (tests.test_mr.MRTest) ... ok
> test_reg_mr_bad_flags (tests.test_mr.MRTest) ... ok
> test_reg_mr_bad_flow (tests.test_mr.MRTest) ... ok
> test_rkey (tests.test_mr.MRTest) ... ok
> test_write (tests.test_mr.MRTest) ... ok
> test_dereg_mw_type1 (tests.test_mr.MWTest) ... ok
> test_dereg_mw_type2 (tests.test_mr.MWTest) ... ok
> test_reg_mw_type1 (tests.test_mr.MWTest) ... ok
> test_reg_mw_type2 (tests.test_mr.MWTest) ... ok
> test_reg_mw_wrong_type (tests.test_mr.MWTest) ... ok
> test_odp_rc_traffic (tests.test_odp.OdpTestCase) ... ok
> test_odp_ud_traffic (tests.test_odp.OdpTestCase) ... skipped 'ODP is not supported - ODP recv not supported'
> test_odp_xrc_traffic (tests.test_odp.OdpTestCase) ... ok
> test_default_allocators (tests.test_parent_domain.ParentDomainTestCase) ... ok
> test_mem_align_allocators (tests.test_parent_domain.ParentDomainTestCase) ... ok
> test_without_allocators (tests.test_parent_domain.ParentDomainTestCase) ... ok
> test_alloc_pd (tests.test_pd.PDTest) ... ok
> test_create_pd_none_ctx (tests.test_pd.PDTest) ... ok
> test_dealloc_pd (tests.test_pd.PDTest) ... ok
> test_destroy_pd_twice (tests.test_pd.PDTest) ... ok
> test_multiple_pd_creation (tests.test_pd.PDTest) ... ok
> test_create_qp_ex_no_attr (tests.test_qp.QPTest) ... ok
> test_create_qp_ex_no_attr_connected (tests.test_qp.QPTest) ... ok
> test_create_qp_ex_with_attr (tests.test_qp.QPTest) ... ok
> test_create_qp_ex_with_attr_connected (tests.test_qp.QPTest) ... ok
> test_create_qp_no_attr (tests.test_qp.QPTest) ... ok
> test_create_qp_no_attr_connected (tests.test_qp.QPTest) ... ok
> test_create_qp_with_attr (tests.test_qp.QPTest) ... ok
> test_create_qp_with_attr_connected (tests.test_qp.QPTest) ... ok
> test_modify_qp (tests.test_qp.QPTest) ... ok
> test_query_qp (tests.test_qp.QPTest) ... ok
> test_rdmacm_sync_traffic (tests.test_rdmacm.CMTestCase) ... skipped 'No devices with net interface'
>
> ======================================================================
> FAIL: test_query_port (tests.test_device.DeviceTest)
> ----------------------------------------------------------------------
> Traceback (most recent call last):
>   File "/kernel_work/rdma-core/tests/test_device.py", line 129, in test_query_port
>     self.verify_port_attr(port_attr)
>   File "/kernel_work/rdma-core/tests/test_device.py", line 113, in verify_port_attr
>     assert 'Invalid' not in d.speed_to_str(attr.active_speed)
> AssertionError

I'm very curious how did you get this assert "d.speed_to_str" covers all
known speeds according to the IBTA.

Thanks

>
> ----------------------------------------------------------------------
> Ran 67 tests in 10.058s
>
> FAILED (failures=1, skipped=3)
>
>
> thanks,
> --
> John Hubbard
> NVIDIA

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3F4289DE4
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 05:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730756AbgJJDSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 23:18:48 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:11466 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730256AbgJJCyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 22:54:20 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f8121a50000>; Fri, 09 Oct 2020 19:51:17 -0700
Received: from [10.2.51.144] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 10 Oct
 2020 02:53:07 +0000
Subject: Re: [PATCH RFC PKS/PMEM 57/58] nvdimm/pmem: Stray access protection
 for pmem->virt_addr
To:     <ira.weiny@intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "Borislav Petkov" <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
CC:     <x86@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-nvdimm@lists.01.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-kselftest@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kexec@lists.infradead.org>,
        <linux-bcache@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <devel@driverdev.osuosl.org>, <linux-efi@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <target-devel@vger.kernel.org>, <linux-nfs@vger.kernel.org>,
        <ceph-devel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
        <linux-aio@kvack.org>, <io-uring@vger.kernel.org>,
        <linux-erofs@lists.ozlabs.org>, <linux-um@lists.infradead.org>,
        <linux-ntfs-dev@lists.sourceforge.net>,
        <reiserfs-devel@vger.kernel.org>,
        <linux-f2fs-devel@lists.sourceforge.net>,
        <linux-nilfs@vger.kernel.org>, <cluster-devel@redhat.com>,
        <ecryptfs@vger.kernel.org>, <linux-cifs@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>, <linux-afs@lists.infradead.org>,
        <linux-rdma@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <drbd-dev@lists.linbit.com>,
        <linux-block@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <linux-cachefs@redhat.com>, <samba-technical@lists.samba.org>,
        <intel-wired-lan@lists.osuosl.org>
References: <20201009195033.3208459-1-ira.weiny@intel.com>
 <20201009195033.3208459-58-ira.weiny@intel.com>
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <bd3f5ece-0e7b-4c15-abbc-1b3b943334dc@nvidia.com>
Date:   Fri, 9 Oct 2020 19:53:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201009195033.3208459-58-ira.weiny@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602298277; bh=hKwlK3WolBLUufkeWDHCi6j+X4NXa8gQFiKyGjbOY3s=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=edx7xet+HWktPTMH7LfazMaeZj84i5/Le7BE3m/9xNKYA9bmh246jZEvn48F/uMcW
         RRn8BggXdwK6EgYw84fvX6LW3WH/wQjijcVtcfekd8K6KkJdzgyiWWhhWRHsAgsUWu
         ErO3rgTi0L/NWozRhmjxim3aejVQ7k0j+Xmczu6ahvjgHQEdG1f6IxukspiHHh4eDZ
         vXW13vRjbU9kKvq3xSMRRweChxuwg1Gt9UWgcBiwICYzh7lbhEKe0zR7+e8y/8iSgu
         9o2Hr0ioZGbS1OLU7+SDtKlkAPg/fZiUxFefl5DnOwU2H5+VRhK6GCiKvAXlVbpTMd
         H8SS1utYxNiTQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/9/20 12:50 PM, ira.weiny@intel.com wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> The pmem driver uses a cached virtual address to access its memory
> directly.  Because the nvdimm driver is well aware of the special
> protections it has mapped memory with, we call dev_access_[en|dis]able()
> around the direct pmem->virt_addr (pmem_addr) usage instead of the
> unnecessary overhead of trying to get a page to kmap.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> ---
>   drivers/nvdimm/pmem.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index fab29b514372..e4dc1ae990fc 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -148,7 +148,9 @@ static blk_status_t pmem_do_read(struct pmem_device *pmem,
>   	if (unlikely(is_bad_pmem(&pmem->bb, sector, len)))
>   		return BLK_STS_IOERR;
>   
> +	dev_access_enable(false);
>   	rc = read_pmem(page, page_off, pmem_addr, len);
> +	dev_access_disable(false);

Hi Ira!

The APIs should be tweaked to use a symbol (GLOBAL, PER_THREAD), instead of
true/false. Try reading the above and you'll see that it sounds like it's
doing the opposite of what it is ("enable_this(false)" sounds like a clumsy
API design to *disable*, right?). And there is no hint about the scope.

And it *could* be so much more readable like this:

     dev_access_enable(DEV_ACCESS_THIS_THREAD);



thanks,
-- 
John Hubbard
NVIDIA

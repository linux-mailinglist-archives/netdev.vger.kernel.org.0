Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC62C28D5F7
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 22:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgJMUxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 16:53:41 -0400
Received: from mga17.intel.com ([192.55.52.151]:54071 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726186AbgJMUxi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 16:53:38 -0400
IronPort-SDR: gI8MkOnOGO61aP07XY6CCWHG9J8FvCUX/dOJGBzQnYJFTP4ej18aKmY+Fn52D+I38Lw4zhRGT9
 RQaSxhwXc52g==
X-IronPort-AV: E=McAfee;i="6000,8403,9773"; a="145845033"
X-IronPort-AV: E=Sophos;i="5.77,371,1596524400"; 
   d="scan'208";a="145845033"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2020 13:53:36 -0700
IronPort-SDR: 6pC5EU5QwoXbsJ9AhSALdpEnefHex0iyEFu7THvX1eaSFNd77CbWePaQQdxa3yUvYDZ6VBgRvg
 Vwn0OOQPMwwA==
X-IronPort-AV: E=Sophos;i="5.77,371,1596524400"; 
   d="scan'208";a="313946459"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2020 13:53:35 -0700
Date:   Tue, 13 Oct 2020 13:52:49 -0700
From:   Ira Weiny <ira.weiny@intel.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kselftest@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kexec@lists.infradead.org, linux-bcache@vger.kernel.org,
        linux-mtd@lists.infradead.org, devel@driverdev.osuosl.org,
        linux-efi@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        linux-um@lists.infradead.org, linux-ntfs-dev@lists.sourceforge.net,
        reiserfs-devel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-nilfs@vger.kernel.org, cluster-devel@redhat.com,
        ecryptfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-rdma@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-cachefs@redhat.com,
        samba-technical@lists.samba.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH RFC PKS/PMEM 24/58] fs/freevxfs: Utilize new kmap_thread()
Message-ID: <20201013205248.GJ2046448@iweiny-DESK2.sc.intel.com>
References: <20201009195033.3208459-1-ira.weiny@intel.com>
 <20201009195033.3208459-25-ira.weiny@intel.com>
 <20201013112544.GA5249@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201013112544.GA5249@infradead.org>
User-Agent: Mutt/1.11.1 (2018-12-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 13, 2020 at 12:25:44PM +0100, Christoph Hellwig wrote:
> > -	kaddr = kmap(pp);
> > +	kaddr = kmap_thread(pp);
> >  	memcpy(kaddr, vip->vii_immed.vi_immed + offset, PAGE_SIZE);
> > -	kunmap(pp);
> > +	kunmap_thread(pp);
> 
> You only Cced me on this particular patch, which means I have absolutely
> no idea what kmap_thread and kunmap_thread actually do, and thus can't
> provide an informed review.

Sorry the list was so big I struggled with who to CC and on which patches.

> 
> That being said I think your life would be a lot easier if you add
> helpers for the above code sequence and its counterpart that copies
> to a potential hughmem page first, as that hides the implementation
> details from most users.

Matthew Wilcox and Al Viro have suggested similar ideas.

https://lore.kernel.org/lkml/20201013205012.GI2046448@iweiny-DESK2.sc.intel.com/

Ira

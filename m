Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D941528AD43
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 06:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgJLEsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 00:48:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:22482 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725917AbgJLEsH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 00:48:07 -0400
IronPort-SDR: D5zKImA/blPs9ugNxSdwTFqrAiCPQ7MfkSDjdD7L1ZPrs2PLYW8mlo8pL00EnU95KhYD7GvV7Z
 Er8+B/ppaVCA==
X-IronPort-AV: E=McAfee;i="6000,8403,9771"; a="183144505"
X-IronPort-AV: E=Sophos;i="5.77,365,1596524400"; 
   d="scan'208";a="183144505"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2020 21:47:58 -0700
IronPort-SDR: OeJlrvjJIthwDW5ZiLkp+F246Fw9BWID0JMdXYyjjISLX5UipnPYleFarWgQdoLnt1ZOhIB0kv
 QrFucSf/AAcw==
X-IronPort-AV: E=Sophos;i="5.77,365,1596524400"; 
   d="scan'208";a="529805779"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2020 21:47:57 -0700
Date:   Sun, 11 Oct 2020 21:47:56 -0700
From:   Ira Weiny <ira.weiny@intel.com>
To:     Bernard Metzler <BMT@zurich.ibm.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Faisal Latif <faisal.latif@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>, x86@kernel.org,
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
        linux-rdma@vger.kernel.org, amd-gfx@lists.freed.esktop.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        drbd-dev@tron.linbit.com, linux-block@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-cachefs@redhat.com,
        samba-technical@lists.samba.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH RFC PKS/PMEM 10/58] drivers/rdma: Utilize new
 kmap_thread()
Message-ID: <20201012044756.GY2046448@iweiny-DESK2.sc.intel.com>
References: <20201009195033.3208459-11-ira.weiny@intel.com>
 <20201009195033.3208459-1-ira.weiny@intel.com>
 <OF849D92D8.F4735ECA-ON002585FD.003F5F27-002585FD.003FCBD6@notes.na.collabserv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF849D92D8.F4735ECA-ON002585FD.003F5F27-002585FD.003FCBD6@notes.na.collabserv.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 10, 2020 at 11:36:49AM +0000, Bernard Metzler wrote:
> -----ira.weiny@intel.com wrote: -----
> 

[snip]

> >@@ -505,7 +505,7 @@ static int siw_tx_hdt(struct siw_iwarp_tx *c_tx,
> >struct socket *s)
> > 				page_array[seg] = p;
> > 
> > 				if (!c_tx->use_sendpage) {
> >-					iov[seg].iov_base = kmap(p) + fp_off;
> >+					iov[seg].iov_base = kmap_thread(p) + fp_off;
> 
> This misses a corresponding kunmap_thread() in siw_unmap_pages()
> (pls change line 403 in siw_qp_tx.c as well)

Thanks I missed that.

Done.

Ira

> 
> Thanks,
> Bernard.
> 

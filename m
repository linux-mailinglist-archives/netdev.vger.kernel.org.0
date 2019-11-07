Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAC19F271E
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 06:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbfKGF0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 00:26:22 -0500
Received: from mga18.intel.com ([134.134.136.126]:53521 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbfKGF0W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 00:26:22 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 21:26:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,276,1569308400"; 
   d="scan'208";a="196446989"
Received: from dpdk-virtio-tbie-2.sh.intel.com (HELO ___) ([10.67.104.74])
  by orsmga008.jf.intel.com with ESMTP; 06 Nov 2019 21:26:19 -0800
Date:   Thu, 7 Nov 2019 13:27:05 +0800
From:   Tiwei Bie <tiwei.bie@intel.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        lingshan.zhu@intel.com
Subject: Re: [PATCH v5] vhost: introduce mdev based hardware backend
Message-ID: <20191107052705.GA28713@___>
References: <20191105115332.11026-1-tiwei.bie@intel.com>
 <16f31c27-3a0e-09d7-3925-dc9777f5e229@redhat.com>
 <20191106122249.GA3235@___>
 <20191106075607-mutt-send-email-mst@kernel.org>
 <580dfa2c-f1ff-2f6f-bbc8-1c4b0a829a3d@redhat.com>
 <20191106144952.GA10926@___>
 <914081d6-40ee-f184-ff43-c3d4cd885fba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <914081d6-40ee-f184-ff43-c3d4cd885fba@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 07, 2019 at 12:08:08PM +0800, Jason Wang wrote:
> On 2019/11/6 下午10:49, Tiwei Bie wrote:
> > > > > > > +	default:
> > > > > > > +		/*
> > > > > > > +		 * VHOST_SET_MEM_TABLE, VHOST_SET_LOG_BASE, and
> > > > > > > +		 * VHOST_SET_LOG_FD are not used yet.
> > > > > > > +		 */
> > > > > > If we don't even use them, there's probably no need to call
> > > > > > vhost_dev_ioctl(). This may help to avoid confusion when we want to develop
> > > > > > new API for e.g dirty page tracking.
> > > > > Good point. It's better to reject these ioctls for now.
> > > > > 
> > > > > PS. One thing I may need to clarify is that, we need the
> > > > > VHOST_SET_OWNER ioctl to get the vq->handle_kick to work.
> > > > > So if we don't call vhost_dev_ioctl(), we will need to
> > > > > call vhost_dev_set_owner() directly.
> > > I may miss something, it looks to me the there's no owner check in
> > > vhost_vring_ioctl() and the vhost_poll_start() can make sure handle_kick
> > > works?
> > Yeah, there is no owner check in vhost_vring_ioctl().
> > IIUC, vhost_poll_start() will start polling the file. And when
> > event arrives, vhost_poll_wakeup() will be called, and it will
> > queue work to work_list and wakeup worker to finish the work.
> > And the worker is created by vhost_dev_set_owner().
> > 
> 
> Right, rethink about this. It looks to me we need:
> 
> - Keep VHOST_SET_OWNER, this could be used for future control vq where it
> needs a kthread to access the userspace memory
> 
> - Temporarily filter  SET_LOG_BASE and SET_LOG_FD until we finalize the API
> for dirty page tracking.
> 
> - For kick through kthread, it looks sub-optimal but we can address this in
> the future, e.g call handle_vq_kick directly in vhost_poll_queue (probably a
> flag for vhost_poll) and deal with the synchronization in vhost_poll_flush
> carefully.

OK.

Thanks,
Tiwei

> 
> Thanks
> 
> 

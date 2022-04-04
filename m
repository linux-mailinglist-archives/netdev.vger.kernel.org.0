Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 131AC4F11F8
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 11:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353969AbiDDJ3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 05:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353794AbiDDJ26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 05:28:58 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F8523BBCB;
        Mon,  4 Apr 2022 02:27:02 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-43-123.pa.nsw.optusnet.com.au [49.180.43.123])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 29B8410E55FB;
        Mon,  4 Apr 2022 19:26:57 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nbIz9-00Dc5C-Sq; Mon, 04 Apr 2022 19:26:55 +1000
Date:   Mon, 4 Apr 2022 19:26:55 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     linux-kernel@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        linux-parisc@vger.kernel.org, sparclinux@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        linux-rdma@vger.kernel.org, linux-um@lists.infradead.org,
        linux-media@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-xfs@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-s390@vger.kernel.org
Subject: Re: Build regressions/improvements in v5.18-rc1
Message-ID: <20220404092655.GR1544202@dread.disaster.area>
References: <CAHk-=wg6FWL1xjVyHx7DdjD2dHZETA5_=FqqW17Z19X-WTfWSg@mail.gmail.com>
 <20220404074734.1092959-1-geert@linux-m68k.org>
 <alpine.DEB.2.22.394.2204041006230.1941618@ramsan.of.borg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.22.394.2204041006230.1941618@ramsan.of.borg>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=624ab9e5
        a=MV6E7+DvwtTitA3W+3A2Lw==:117 a=MV6E7+DvwtTitA3W+3A2Lw==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=6Fu7hv2xAAAA:8 a=7-415B0cAAAA:8
        a=L05BbbQJD6-TbP0LrSsA:9 a=CjuIK1q_8ugA:10 a=OCr_TKDY-yBPQKLGgHr3:22
        a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 04, 2022 at 10:16:08AM +0200, Geert Uytterhoeven wrote:
> On Mon, 4 Apr 2022, Geert Uytterhoeven wrote:
> > Below is the list of build error/warning regressions/improvements in
> > v5.18-rc1[1] compared to v5.17[2].
> > 
> > Summarized:
> >  - build errors: +36/-15
> >  - build warnings: +5/-38
> > 
> > Happy fixing! ;-)

Well....

> >  + /kisskb/src/fs/xfs/xfs_buf.h: error: initializer element is not constant:  => 46:23

Looking at:

http://kisskb.ellerman.id.au/kisskb/buildresult/14714961/

The build error is:

/kisskb/src/fs/xfs/./xfs_trace.h:432:2: note: in expansion of macro 'TP_printk'
  TP_printk("dev %d:%d daddr 0x%llx bbcount 0x%x hold %d pincount %d "
  ^
/kisskb/src/fs/xfs/./xfs_trace.h:440:5: note: in expansion of macro '__print_flags'
     __print_flags(__entry->flags, "|", XFS_BUF_FLAGS),
     ^
/kisskb/src/fs/xfs/xfs_buf.h:67:4: note: in expansion of macro 'XBF_UNMAPPED'
  { XBF_UNMAPPED,  "UNMAPPED" }
    ^
/kisskb/src/fs/xfs/./xfs_trace.h:440:40: note: in expansion of macro 'XFS_BUF_FLAGS'
     __print_flags(__entry->flags, "|", XFS_BUF_FLAGS),
                                        ^
/kisskb/src/fs/xfs/./xfs_trace.h: In function 'trace_raw_output_xfs_buf_flags_class':
/kisskb/src/fs/xfs/xfs_buf.h:46:23: error: initializer element is not constant
 #define XBF_UNMAPPED  (1 << 31)/* do not map the buffer */

This doesn't make a whole lotta sense to me. It's blown up in a
tracepoint macro in XFS that was not changed at all in 5.18-rc1, nor
was any of the surrounding XFS code or contexts.  Perhaps something
outside XFS changed to cause this on these platforms?

Can you bisect this, please?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

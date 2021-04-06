Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33550354D4D
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 09:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244138AbhDFHHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 03:07:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:60650 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244136AbhDFHHI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 03:07:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B3F3FAFAA;
        Tue,  6 Apr 2021 07:06:59 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 1809D60441; Tue,  6 Apr 2021 09:06:59 +0200 (CEST)
Date:   Tue, 6 Apr 2021 09:06:59 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Jiri Kosina <jikos@kernel.org>, Hillf Danton <hdanton@sina.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kehuan Feng <kehuan.feng@gmail.com>,
        Jike Song <albcamus@gmail.com>,
        Jonas Bonn <jonas.bonn@netrounds.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, Josh Hunt <johunt@akamai.com>
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
Message-ID: <20210406070659.t6csfgkskbmmxtx5@lion.mk-sys.cz>
References: <20200827125747.5816-1-hdanton@sina.com>
 <CACS=qq+a0H=e8yLFu95aE7Hr0bQ9ytCBBn2rFx82oJnPpkBpvg@mail.gmail.com>
 <CAM_iQpV-JMURzFApp-Zhxs3QN9j=Zdf6yqwOP=E42ERDHxe6Hw@mail.gmail.com>
 <dd73f551d1fc89e457ffabd106cbf0bf401b747b.camel@redhat.com>
 <CAM_iQpXZMeAGkq_=rG6KEabFNykszpRU_Hnv65Qk7yesvbRDrw@mail.gmail.com>
 <5f51cbad3cc2_3eceb208fc@john-XPS-13-9370.notmuch>
 <nycvar.YFH.7.76.2104022120050.12405@cbobk.fhfr.pm>
 <20210403003537.2032-1-hdanton@sina.com>
 <nycvar.YFH.7.76.2104031420470.12405@cbobk.fhfr.pm>
 <eaff25bc-9b64-037e-b9bc-c06fc4a5a9fb@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eaff25bc-9b64-037e-b9bc-c06fc4a5a9fb@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 08:55:41AM +0800, Yunsheng Lin wrote:
> 
> Hi, Jiri
> Do you have a reproducer that can be shared here?
> With reproducer, I can debug and test it myself too.

I'm afraid we are not aware of a simple reproducer. As mentioned in the
original discussion, the race window is extremely small and the other
thread has to do quite a lot in the meantime which is probably why, as
far as I know, this was never observed on real hardware, only in
virtualization environments. NFS may also be important as, IIUC, it can
often issue an RPC request from a different CPU right after a data
transfer. Perhaps you could cheat a bit and insert a random delay
between the empty queue check and releasing q->seqlock to make it more
likely to happen.

Other than that, it's rather just "run this complex software in a xen VM
and wait".

Michal

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82083494B19
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 10:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237912AbiATJvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 04:51:44 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:1252 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237302AbiATJvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 04:51:43 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R801e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V2Lw80i_1642672291;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V2Lw80i_1642672291)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 20 Jan 2022 17:51:31 +0800
Date:   Thu, 20 Jan 2022 17:51:30 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     Guangguan Wang <guangguan.wang@linux.alibaba.com>,
        kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next] net/smc: Introduce receive queue flow
 control support
Message-ID: <20220120095130.GB41938@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20220120065140.5385-1-guangguan.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220120065140.5385-1-guangguan.wang@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 02:51:40PM +0800, Guangguan Wang wrote:
>This implement rq flow control in smc-r link layer. QPs
>communicating without rq flow control, in the previous
>version, may result in RNR (reveive not ready) error, which
>means when sq sends a message to the remote qp, but the
>remote qp's rq has no valid rq entities to receive the message.
>In RNR condition, the rdma transport layer may retransmit
>the messages again and again until the rq has any entities,
>which may lower the performance, especially in heavy traffic.
>Using credits to do rq flow control can avoid the occurrence
>of RNR.

I'm wondering if SRQ can be used to solve this problem ?

One of my concern on credit-base flow control is if the RTT is
a bit longer, we may have to wait RTT/2 for peer to grant us credit
before we can really send more data. That may decrease the maximium
bandwidth we can achive in this case.


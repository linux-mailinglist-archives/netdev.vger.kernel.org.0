Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B726E2CDEF9
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 20:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbgLCT2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 14:28:22 -0500
Received: from smtp3.cs.stanford.edu ([171.64.64.27]:32786 "EHLO
        smtp3.cs.Stanford.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbgLCT2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 14:28:21 -0500
X-Greylist: delayed 1421 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Dec 2020 14:28:21 EST
Received: from mail-lj1-f178.google.com ([209.85.208.178]:33436)
        by smtp3.cs.Stanford.EDU with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92.3)
        (envelope-from <ouster@cs.stanford.edu>)
        id 1kkttX-0002eI-QG
        for netdev@vger.kernel.org; Thu, 03 Dec 2020 11:04:00 -0800
Received: by mail-lj1-f178.google.com with SMTP id t22so3784549ljk.0
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 11:03:59 -0800 (PST)
X-Gm-Message-State: AOAM533RbaK/b5gFY62VVnGYqO6Do+Go8iAKFbWX2Ng8aJv/AHVuERr3
        kiyVe04Lc0KEWSQX6oc7JkD8w3YBpmzk9XKRTUo=
X-Google-Smtp-Source: ABdhPJwuf90sYp9kQ3ej4lsxt41Qy7gIfoSux0sWbRZsWBVELILuNryR0/irI9Uyz8tZtnO7kqe2tbS4mr992v2+/9c=
X-Received: by 2002:a05:651c:315:: with SMTP id a21mr1669065ljp.229.1607022238607;
 Thu, 03 Dec 2020 11:03:58 -0800 (PST)
MIME-Version: 1.0
From:   John Ousterhout <ouster@cs.stanford.edu>
Date:   Thu, 3 Dec 2020 11:03:21 -0800
X-Gmail-Original-Message-ID: <CAGXJAmx_xQr56oiak8k8MC+JPBNi+tQBtTvBRqYVsimmKtW4MA@mail.gmail.com>
Message-ID: <CAGXJAmx_xQr56oiak8k8MC+JPBNi+tQBtTvBRqYVsimmKtW4MA@mail.gmail.com>
Subject: GRO: can't force packet up stack immediately?
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Score: -1.0
X-Spam-Level: 
X-Spam-Checker-Version: SpamAssassin on smtp3.cs.Stanford.EDU
X-Scan-Signature: 9c8d7c79e82d9ccd3af9a51b4d3246f3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I recently upgraded my kernel module implementing the Homa transport
protocol from 4.15.18 to 5.4.80, and a GRO feature available in the
older version seems to have gone away in the newer version. In
particular, it used to be possible for a protocol's xxx_gro_receive
function to force a packet up the stack immediately by returning that
skb as the result of xxx_gro_receive. However, in the newer kernel
version, these packets simply get queued on napi->rx_list; the queue
doesn't get flushed up-stack until napi_complete_done is called or
gro_normal_batch packets accumulate. For Homa, this extra level of
queuing gets in the way.

Is there any way for a xxx_gro_receive function to force a packet (in
particular, one of those in the list passed as first argument to
xxx_gro_receive) up the protocol stack immediately? I suppose I could
set gro_normal_batch to 1, but that might interfere with other
protocols that really want the batching.

-John-

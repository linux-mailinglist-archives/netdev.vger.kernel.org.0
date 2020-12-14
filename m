Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9533C2D9577
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 10:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731354AbgLNJqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 04:46:16 -0500
Received: from mga12.intel.com ([192.55.52.136]:15941 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725915AbgLNJqA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 04:46:00 -0500
IronPort-SDR: 4JpOQfKI4w9XTKue5pJciit1apAhHfSSXtJItHBD5fXboxUdoah3XhuYy8mFdCfDBRDJPEgr1W
 PQ9gONkN3BGQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9834"; a="153912887"
X-IronPort-AV: E=Sophos;i="5.78,418,1599548400"; 
   d="scan'208";a="153912887"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2020 01:45:18 -0800
IronPort-SDR: +re/1AvMgKbhZDoQkYxiPpFcs5+R7eszN7Z65+JzNsWtJW/cLZ8NDhUvpznLlVtOx+FFlSa3MO
 DUyI/7MN4bJA==
X-IronPort-AV: E=Sophos;i="5.78,418,1599548400"; 
   d="scan'208";a="367240191"
Received: from zhangfa1-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.57.48])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2020 01:45:16 -0800
Subject: Re: [PATCH bpf] xsk: fix memory leak for failed bind
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org,
        syzbot+cfa88ddd0655afa88763@syzkaller.appspotmail.com
References: <20201214085127.3960-1-magnus.karlsson@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <33bc9c55-cc20-ee6a-2356-86861c271b47@intel.com>
Date:   Mon, 14 Dec 2020 10:45:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201214085127.3960-1-magnus.karlsson@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-14 09:51, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Fix a possible memory leak when a bind of an AF_XDP socket fails. When
> the fill and completion rings are created, they are tied to the
> socket. But when the buffer pool is later created at bind time, the
> ownership of these two rings are transferred to the buffer pool as
> they might be shared between sockets (and the buffer pool cannot be
> created until we know what we are binding to). So, before the buffer
> pool is created, these two rings are cleaned up with the socket, and
> after they have been transferred they are cleaned up together with
> the buffer pool.
> 
> The problem is that ownership was transferred before it was absolutely
> certain that the buffer pool could be created and initialized
> correctly and when one of these errors occurred, the fill and
> completion rings did neither belong to the socket nor the pool and
> where therefore leaked. Solve this by moving the ownership transfer
> to the point where the buffer pool has been completely set up and
> there is no way it can fail.
> 
> Fixes: 7361f9c3d719 ("xsk: Move fill and completion rings to buffer pool")
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> Reported-by: syzbot+cfa88ddd0655afa88763@syzkaller.appspotmail.com

Acked-by: Björn Töpel <bjorn.topel@intel.com>

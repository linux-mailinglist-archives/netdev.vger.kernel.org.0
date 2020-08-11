Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D42C9241B8A
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 15:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728708AbgHKNUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 09:20:12 -0400
Received: from www62.your-server.de ([213.133.104.62]:59496 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728516AbgHKNUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 09:20:12 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k5UC8-0004uL-KX; Tue, 11 Aug 2020 15:20:00 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k5UC8-000Bp1-Dr; Tue, 11 Aug 2020 15:20:00 +0200
Subject: Re: [PATCH bpf-next v2] bpf: fix segmentation fault of test_progs
To:     Jianlin Lv <Jianlin.Lv@arm.com>, bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org, yhs@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20200807172016.150952-1-Jianlin.Lv@arm.com>
 <20200810153940.125508-1-Jianlin.Lv@arm.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <066bc6b8-8e08-e473-b454-4544e99ad7e0@iogearbox.net>
Date:   Tue, 11 Aug 2020 15:19:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200810153940.125508-1-Jianlin.Lv@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25900/Mon Aug 10 14:44:29 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/10/20 5:39 PM, Jianlin Lv wrote:
> test_progs reports the segmentation fault as below
> 
> $ sudo ./test_progs -t mmap --verbose
> test_mmap:PASS:skel_open_and_load 0 nsec
> ......
> test_mmap:PASS:adv_mmap1 0 nsec
> test_mmap:PASS:adv_mmap2 0 nsec
> test_mmap:PASS:adv_mmap3 0 nsec
> test_mmap:PASS:adv_mmap4 0 nsec
> Segmentation fault
> 
> This issue was triggered because mmap() and munmap() used inconsistent
> length parameters; mmap() creates a new mapping of 3*page_size, but the
> length parameter set in the subsequent re-map and munmap() functions is
> 4*page_size; this leads to the destruction of the process space.
> 
> To fix this issue, first create 4 pages of anonymous mapping,then do all
> the mmap() with MAP_FIXED.
> 
> Another issue is that when unmap the second page fails, the length
> parameter to delete tmp1 mappings should be 4*page_size.
> 
> Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>

Applied, thanks!

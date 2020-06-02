Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA51A1EBF59
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 17:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbgFBPs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 11:48:57 -0400
Received: from www62.your-server.de ([213.133.104.62]:44268 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgFBPs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 11:48:56 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jg99q-0003Uw-QZ; Tue, 02 Jun 2020 17:48:54 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jg99q-0003Xd-JC; Tue, 02 Jun 2020 17:48:54 +0200
Subject: Re: [PATCH bpf 3/3] bpf, selftests: Adapt cls_redirect to call
 csum_level helper
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
References: <cover.1591108731.git.daniel@iogearbox.net>
 <e7458f10e3f3d795307cbc5ad870112671d9c6f7.1591108731.git.daniel@iogearbox.net>
 <CACAyw998Yy6NBJbSi+RfUofpKQYjYA78HGmWEqDTm1B+BkvuOw@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <65cde627-96af-b99e-7a6f-a688c2c6dbdd@iogearbox.net>
Date:   Tue, 2 Jun 2020 17:48:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CACAyw998Yy6NBJbSi+RfUofpKQYjYA78HGmWEqDTm1B+BkvuOw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25831/Tue Jun  2 14:41:03 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/2/20 5:13 PM, Lorenz Bauer wrote:
> On Tue, 2 Jun 2020 at 15:58, Daniel Borkmann <daniel@iogearbox.net> wrote:
>>
>> Adapt bpf_skb_adjust_room() to pass in BPF_F_ADJ_ROOM_NO_CSUM_RESET flag and
>> use the new bpf_csum_level() helper to inc/dec the checksum level by one after
>> the encap/decap.
> 
> Just to be on the safe side: we go from
>      | ETH | IP | UDP | GUE | IP | TCP |
> to
>      | ETH | IP | TCP |
> by cutting | IP | UDP | GUE | after the Ethernet header.
> 
> Since IP is never included in csum_level and because GUE is not eligible for
> CHECKSUM_UNNECESSARY we only need to do csum_level-- once, not twice.

Yes, that is correct.

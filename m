Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55ACD1967F9
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 18:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgC1ROc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 13:14:32 -0400
Received: from www62.your-server.de ([213.133.104.62]:59022 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgC1ROc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 13:14:32 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jIF2Q-0001nu-OY; Sat, 28 Mar 2020 18:14:26 +0100
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jIF2Q-0002jX-Br; Sat, 28 Mar 2020 18:14:26 +0100
Subject: Re: [PATCH bpf-next] xsk: Init all ring members in xsk_umem__create
 and xsk_socket__create
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        Fletcher Dunn <fletcherd@valvesoftware.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Brandon Gilmore <bgilmore@valvesoftware.com>,
        Steven Noonan <steven@valvesoftware.com>
References: <85f12913cde94b19bfcb598344701c38@valvesoftware.com>
 <CAJ8uoz2M0Xj_maD3jZeZedrUXGNJqvbV_DyC2A8Yh9R6z7gfsg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ae371400-e37f-bbac-691e-cc50235f1ee0@iogearbox.net>
Date:   Sat, 28 Mar 2020 18:14:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAJ8uoz2M0Xj_maD3jZeZedrUXGNJqvbV_DyC2A8Yh9R6z7gfsg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25765/Sat Mar 28 14:16:42 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/28/20 10:18 AM, Magnus Karlsson wrote:
> On Fri, Mar 27, 2020 at 4:40 AM Fletcher Dunn
> <fletcherd@valvesoftware.com> wrote:
>>
>> Fix a sharp edge in xsk_umem__create and xsk_socket__create.  Almost all of
>> the members of the ring buffer structs are initialized, but the "cached_xxx"
>> variables are not all initialized.  The caller is required to zero them.
>> This is needlessly dangerous.  The results if you don't do it can be very bad.
>> For example, they can cause xsk_prod_nb_free and xsk_cons_nb_avail to return
>> values greater than the size of the queue.  xsk_ring_cons__peek can return an
>> index that does not refer to an item that has been queued.
>>
>> I have confirmed that without this change, my program misbehaves unless I
>> memset the ring buffers to zero before calling the function.  Afterwards,
>> my program works without (or with) the memset.
> 
> Thank you Flecther for catching this. Appreciated.
> 
> /Magnus
> 
> Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

Applied, thanks!

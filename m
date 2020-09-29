Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90BDF27D6B4
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 21:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728565AbgI2TSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 15:18:18 -0400
Received: from www62.your-server.de ([213.133.104.62]:33262 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgI2TSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 15:18:17 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kNL8g-0006H3-Oy; Tue, 29 Sep 2020 21:18:14 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kNL8g-000RKE-Ha; Tue, 29 Sep 2020 21:18:14 +0200
Subject: Re: [PATCH bpf-next 1/2] bpf: introduce BPF_F_SHARE_PE for perf event
 array
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com, ast@kernel.org,
        john.fastabend@gmail.com, kpsingh@chromium.org
References: <20200929084750.419168-1-songliubraving@fb.com>
 <20200929084750.419168-2-songliubraving@fb.com>
 <04ba2027-a5ad-d715-ffc8-67f13e40f2d2@iogearbox.net>
 <20200929190054.4a2chcuxuvicndtu@ast-mbp.dhcp.thefacebook.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <7c13d40b-fe79-ddbf-2a37-abae1b44de71@iogearbox.net>
Date:   Tue, 29 Sep 2020 21:18:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200929190054.4a2chcuxuvicndtu@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25942/Tue Sep 29 15:56:33 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/29/20 9:00 PM, Alexei Starovoitov wrote:
> On Tue, Sep 29, 2020 at 04:02:10PM +0200, Daniel Borkmann wrote:
>>> +
>>> +/* Share perf_event among processes */
>>> +	BPF_F_SHARE_PE		= (1U << 11),
>>
>> nit but given UAPI: maybe name into something more self-descriptive
>> like BPF_F_SHAREABLE_EVENT ?
> 
> I'm not happy with either name.
> It's not about sharing and not really about perf event.
> I think the current behavior of perf_event_array is unusual and surprising.
> Sadly we cannot fix it without breaking user space, so flag is needed.
> How about BPF_F_STICKY_OBJECTS or BPF_F_PRESERVE_OBJECTS
> or the same with s/OBJECTS/FILES/ ?

Sounds good to me, BPF_F_PRESERVE_OBJECTS or _ENTRIES seems reasonable.

>>> +static void perf_event_fd_array_map_free(struct bpf_map *map)
>>> +{
>>> +	struct bpf_event_entry *ee;
>>> +	struct bpf_array *array;
>>> +	int i;
>>> +
>>> +	if ((map->map_flags & BPF_F_SHARE_PE) == 0) {
>>> +		fd_array_map_free(map);
>>> +		return;
>>> +	}
>>> +
>>> +	array = container_of(map, struct bpf_array, map);
>>> +	for (i = 0; i < array->map.max_entries; i++) {
>>> +		ee = READ_ONCE(array->ptrs[i]);
>>> +		if (ee)
>>> +			fd_array_map_delete_elem(map, &i);
>>> +	}
>>> +	bpf_map_area_free(array);
>>
>> Why not simplify into:
>>
>> 	if (map->map_flags & BPF_F_SHAREABLE_EVENT)
>> 		bpf_fd_array_map_clear(map);
>> 	fd_array_map_free(map);
> 
> +1
> 
>>> +}
>>> +
>>>    static void *prog_fd_array_get_ptr(struct bpf_map *map,
>>>    				   struct file *map_file, int fd)
>>>    {
>>> @@ -1134,6 +1158,9 @@ static void perf_event_fd_array_release(struct bpf_map *map,
>>>    	struct bpf_event_entry *ee;
>>>    	int i;
> 
> add empty line pls.
> 
>>> +	if (map->map_flags & BPF_F_SHARE_PE)
>>> +		return;
>>> +


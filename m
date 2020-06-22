Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30F5D20433D
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 00:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730853AbgFVWE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 18:04:29 -0400
Received: from www62.your-server.de ([213.133.104.62]:45882 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730701AbgFVWE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 18:04:29 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jnUYF-0000O3-B2; Tue, 23 Jun 2020 00:04:27 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jnUYF-0004EY-2n; Tue, 23 Jun 2020 00:04:27 +0200
Subject: Re: [PATCH bpf-next] libbpf: add a bunch of attribute getters/setters
 for map definitions
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20200621062112.3006313-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c14944c8-2752-f35b-9d88-7c47c65900da@iogearbox.net>
Date:   Tue, 23 Jun 2020 00:04:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200621062112.3006313-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25851/Mon Jun 22 15:09:36 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/21/20 8:21 AM, Andrii Nakryiko wrote:
> Add a bunch of getter for various aspects of BPF map. Some of these attribute
> (e.g., key_size, value_size, type, etc) are available right now in struct
> bpf_map_def, but this patch adds getter allowing to fetch them individually.
> bpf_map_def approach isn't very scalable, when ABI stability requirements are
> taken into account. It's much easier to extend libbpf and add support for new
> features, when each aspect of BPF map has separate getter/setter.
> 
> Getters follow the common naming convention of not explicitly having "get" in
> its name: bpf_map__type() returns map type, bpf_map__key_size() returns
> key_size. Setters, though, explicitly have set in their name:
> bpf_map__set_type(), bpf_map__set_key_size().
> 
> This patch ensures we now have a getter and a setter for the following
> map attributes:
>    - type;
>    - max_entries;
>    - map_flags;
>    - numa_node;
>    - key_size;
>    - value_size;
>    - ifindex.
> 
> bpf_map__resize() enforces unnecessary restriction of max_entries > 0. It is
> unnecessary, because libbpf actually supports zero max_entries for some cases
> (e.g., for PERF_EVENT_ARRAY map) and treats it specially during map creation
> time. To allow setting max_entries=0, new bpf_map__set_max_entries() setter is
> added. bpf_map__resize()'s behavior is preserved for backwards compatibility
> reasons.
> 
> Map ifindex getter is added as well. There is a setter already, but no
> corresponding getter. Fix this assymetry as well. bpf_map__set_ifindex()
> itself is converted from void function into error-returning one, similar to
> other setters. The only error returned right now is -EBUSY, if BPF map is
> already loaded and has corresponding FD.
> 
> One lacking attribute with no ability to get/set or even specify it
> declaratively is numa_node. This patch fixes this gap and both adds
> programmatic getter/setter, as well as adds support for numa_node field in
> BTF-defined map.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Lgtm, applied, thanks!

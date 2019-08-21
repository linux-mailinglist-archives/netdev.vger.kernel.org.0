Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5719D97816
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 13:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbfHULko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 07:40:44 -0400
Received: from www62.your-server.de ([213.133.104.62]:42162 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbfHULko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 07:40:44 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1i0Oyo-0002GX-6C; Wed, 21 Aug 2019 13:40:42 +0200
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=pc-66.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1i0Oyn-0004nc-QB; Wed, 21 Aug 2019 13:40:42 +0200
Subject: Re: [PATCH bpf-next 2/2] tools: bpftool: add "bpftool map freeze"
 subcommand
To:     Quentin Monnet <quentin.monnet@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com
References: <20190821085219.30387-1-quentin.monnet@netronome.com>
 <20190821085219.30387-3-quentin.monnet@netronome.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b44cf34c-b6d5-a3f5-f386-e70791e47229@iogearbox.net>
Date:   Wed, 21 Aug 2019 13:40:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190821085219.30387-3-quentin.monnet@netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25548/Wed Aug 21 10:27:18 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/21/19 10:52 AM, Quentin Monnet wrote:
> Add a new subcommand to freeze maps from user space.
> 
> Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> ---
>   .../bpf/bpftool/Documentation/bpftool-map.rst |  9 +++++
>   tools/bpf/bpftool/bash-completion/bpftool     |  4 +--
>   tools/bpf/bpftool/map.c                       | 34 ++++++++++++++++++-
>   3 files changed, 44 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/Documentation/bpftool-map.rst b/tools/bpf/bpftool/Documentation/bpftool-map.rst
> index 61d1d270eb5e..1c0f7146aab0 100644
> --- a/tools/bpf/bpftool/Documentation/bpftool-map.rst
> +++ b/tools/bpf/bpftool/Documentation/bpftool-map.rst
> @@ -36,6 +36,7 @@ MAP COMMANDS
>   |	**bpftool** **map pop**        *MAP*
>   |	**bpftool** **map enqueue**    *MAP* **value** *VALUE*
>   |	**bpftool** **map dequeue**    *MAP*
> +|	**bpftool** **map freeze**     *MAP*
>   |	**bpftool** **map help**
>   |
>   |	*MAP* := { **id** *MAP_ID* | **pinned** *FILE* }
> @@ -127,6 +128,14 @@ DESCRIPTION
>   	**bpftool map dequeue**  *MAP*
>   		  Dequeue and print **value** from the queue.
>   
> +	**bpftool map freeze**  *MAP*
> +		  Freeze the map as read-only from user space. Entries from a
> +		  frozen map can not longer be updated or deleted with the
> +		  **bpf\ ()** system call. This operation is not reversible,
> +		  and the map remains immutable from user space until its
> +		  destruction. However, read and write permissions for BPF
> +		  programs to the map remain unchanged.

That is not correct, programs that are loaded into the system /after/ the map
has been frozen cannot modify values either, thus read-only from both sides.

Thanks,
Daniel

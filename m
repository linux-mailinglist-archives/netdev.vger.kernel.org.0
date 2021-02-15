Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2FF31BE82
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 17:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbhBOQMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 11:12:44 -0500
Received: from mga01.intel.com ([192.55.52.88]:48700 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232512AbhBOQIm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 11:08:42 -0500
IronPort-SDR: ZtTs3yYrOlrlZgG/i7nMbvKMubmIVtUANt7jCyJVnecb5Lz7/7NnVyJgv34kmmykJRtBmk6j2v
 t75fjT+Rdmyg==
X-IronPort-AV: E=McAfee;i="6000,8403,9896"; a="201889627"
X-IronPort-AV: E=Sophos;i="5.81,181,1610438400"; 
   d="scan'208";a="201889627"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 08:08:01 -0800
IronPort-SDR: Y5W9vSJkAEp2u3X2x4TzcJh3aaw8ur1VxdtABIAheOyl6FvYV26EmyAWfC7KVtv3QGJvsW4NUc
 kn4mdCvHuoGA==
X-IronPort-AV: E=Sophos;i="5.81,181,1610438400"; 
   d="scan'208";a="399129104"
Received: from wwantka-mobl2.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.54.83])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 08:07:58 -0800
Subject: Re: [PATCH bpf-next 0/3] Introduce bpf_link in libbpf's xsk
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        daniel@iogearbox.net, ast@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     andrii@kernel.org, toke@redhat.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com
References: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <3a625c8b-6dc0-3933-25e5-f747197ae1f4@intel.com>
Date:   Mon, 15 Feb 2021 17:07:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-02-15 16:46, Maciej Fijalkowski wrote:
> Hi,
> 
> This set is another approach towards addressing the below issue:
> 
> // load xdp prog and xskmap and add entry to xskmap at idx 10
> $ sudo ./xdpsock -i ens801f0 -t -q 10
> 
> // add entry to xskmap at idx 11
> $ sudo ./xdpsock -i ens801f0 -t -q 11
> 
> terminate one of the processes and another one is unable to work due to
> the fact that the XDP prog was unloaded from interface.
> 
> Previous attempt was, to put it mildly, a bit broken, as there was no
> synchronization between updates to additional map, as Bjorn pointed out.
> See https://lore.kernel.org/netdev/20190603131907.13395-5-maciej.fijalkowski@intel.com/
> 
> In the meantime bpf_link was introduced and it seems that it can address
> the issue of refcounting the XDP prog on interface. More info on commit
> messages.
>

For the series:

Reviewed-by: Björn Töpel <bjorn.topel@intel.com>
Acked-by: Björn Töpel <bjorn.topel@intel.com>

Finally, bpf_link/scoped XDP support! Thanks a lot!


Björn



> Thanks.
> 
> Maciej Fijalkowski (3):
>    libbpf: xsk: use bpf_link
>    libbpf: clear map_info before each bpf_obj_get_info_by_fd
>    samples: bpf: do not unload prog within xdpsock
> 
>   samples/bpf/xdpsock_user.c |  55 ++++----------
>   tools/lib/bpf/xsk.c        | 147 +++++++++++++++++++++++++++++++------
>   2 files changed, 139 insertions(+), 63 deletions(-)
> 

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D14A176DFA
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 05:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgCCE1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 23:27:13 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:40996 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726859AbgCCE1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 23:27:13 -0500
Received: by mail-qv1-f68.google.com with SMTP id s15so1081099qvn.8
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 20:27:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZU2lttPJS0xjsIlYUb4JeChQQ5E7UBYtrGko1Hz2FRw=;
        b=RjQc9TOas4prHHcg64vxVvW6G/WnzjMUoymAffyLmzT4cm0EmL/kVPcATBwYKrt9DW
         Glx7ibkeeKsL/rEscRG1VsToaRfMP5pqToOhgQvI+gHVGqLc+krfgam/VrGwFVe+1v4L
         YLw1C25NGuyHE+3UUmssDDkS713zS00Ht9e88=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZU2lttPJS0xjsIlYUb4JeChQQ5E7UBYtrGko1Hz2FRw=;
        b=nUWFkKB98KneJq62p8oaNHYrkbQGZWa9hWRgyFiGeXBxBUE6rcJfaDMDwiunVNNhpf
         jKE9V2qfGtlTVaZp5+sYWx6P57McNL5nlZNRS1vk5GoD094CWGIBn4igr6H5pl8ZVJD4
         CSQYZsrp6d0DvStjOVDhbCXuN+iYG5AYD8lnnj4+8IXKZaKyJcomEXBGLoQJi4LhOe/B
         dNq+d4p+boK1H3ODDYsxyNeWdnaWsXNvHfQNfvt6YsIARiB3khXQGZBgxjY+xahrdFQe
         F/jRdxAHz1KvK7GDJSgawRSCbroyAOU7OhnD/VTTQMi0EoAVqemyLCSwmhV1gjmgx0Z6
         0v6w==
X-Gm-Message-State: ANhLgQ21oJHiXaYJ/Je6vXWQvTClQ3ZYp65h0LKLXtopPw6die6ApP9K
        CX2EnbyKGctPqLv2LGkiVm6heA==
X-Google-Smtp-Source: ADFU+vsn89SPKi/0DmGG84VKoz59dnzut1dHY4bYE+lrd8JkmiHMb4P6zwUrQ4jnhEFjcOSlOI8PMg==
X-Received: by 2002:ad4:4e88:: with SMTP id dy8mr2521535qvb.118.1583209632211;
        Mon, 02 Mar 2020 20:27:12 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:e4d9:7c4:8bbe:590? ([2601:282:803:7700:e4d9:7c4:8bbe:590])
        by smtp.gmail.com with ESMTPSA id t13sm11191586qkm.60.2020.03.02.20.27.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 20:27:11 -0800 (PST)
Subject: Re: [PATCH RFC v4 bpf-next 09/11] tun: Support xdp in the Tx path for
 xdp_frames
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com
References: <20200227032013.12385-1-dsahern@kernel.org>
 <20200227032013.12385-10-dsahern@kernel.org>
 <20200302183040.tgnrg6tkblrjwsqj@ast-mbp>
From:   David Ahern <dahern@digitalocean.com>
Message-ID: <318c0a44-b540-1c7f-9667-c01da5a8ac73@digitalocean.com>
Date:   Mon, 2 Mar 2020 21:27:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200302183040.tgnrg6tkblrjwsqj@ast-mbp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/2/20 11:30 AM, Alexei Starovoitov wrote:
> On Wed, Feb 26, 2020 at 08:20:11PM -0700, David Ahern wrote:
>> +
>> +		act = bpf_prog_run_xdp(xdp_prog, &xdp);
>> +		switch (act) {
>> +		case XDP_TX:    /* for Tx path, XDP_TX == XDP_PASS */
>> +			act = XDP_PASS;
>> +			break;
>> +		case XDP_PASS:
>> +			break;
>> +		case XDP_REDIRECT:
>> +			/* fall through */
>> +		default:
>> +			bpf_warn_invalid_xdp_action(act);
>> +			/* fall through */
>> +		case XDP_ABORTED:
>> +			trace_xdp_exception(tun->dev, xdp_prog, act);
>> +			/* fall through */
>> +		case XDP_DROP:
>> +			break;
>> +		}
> 
> patch 8 has very similar switch. Can you share the code?

Most likely; I'll take a look.

> 
> I'm worried that XDP_TX is a silent alias to XDP_PASS.
> What were the reasons to go with this approach?

As I stated in the cover letter:

"XDP_TX on Rx means send the packet out the device it arrived
on; given that, XDP_Tx for the Tx path is treated as equivalent to
XDP_PASS - ie., continue on the Tx path."

> imo it's less error prone and extensible to warn on XDP_TX.
> Which will mean that both XDP_TX and XDP_REDICT are not supported for egress atm.

I personally don't care either way; I was going with the simplest
concept from a user perspective.

> 
> Patches 8 and 9 cover tun only. I'd like to see egress hook to be implemented
> in at least one physical NIC. Pick any hw. Something that handles real frames.
> Adding this hook to virtual NIC is easy, but it doesn't demonstrate design
> trade-offs one would need to think through by adding egress hook to physical
> nic. That's why I think it's mandatory to have it as part of the patch set.
> 
> Patch 11 exposes egress to samples/bpf. It's nice, but without selftests it's
> no go. All new features must be exercised as part of selftests/bpf.

Patches that exercise the rtnetlink uapi are fairly easy to do on single
node; anything traffic related requires multiple nodes or namespace
level capabilities.  Unless I am missing something that is why all
current XDP tests ride on top of veth; veth changes are not part of this
set.

So to be clear you are saying that all new XDP features require patches
to a h/w nic, veth and whatever the author really cares about before new
features like this go in?

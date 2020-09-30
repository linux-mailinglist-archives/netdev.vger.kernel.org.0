Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75FD27E327
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 09:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728557AbgI3H6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 03:58:19 -0400
Received: from www62.your-server.de ([213.133.104.62]:36092 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbgI3H6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 03:58:19 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kNX07-0000dO-5S; Wed, 30 Sep 2020 09:58:11 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kNX06-000J9Y-SH; Wed, 30 Sep 2020 09:58:10 +0200
Subject: Re: [PATCH bpf-next v3 3/6] bpf: add redirect_neigh helper as
 redirect drop-in
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     ast@kernel.org, john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, David Ahern <dsahern@kernel.org>
References: <cover.1601414174.git.daniel@iogearbox.net>
 <f46cce33255c0c00b8c64393a7a419253dd0b949.1601414174.git.daniel@iogearbox.net>
 <20200930064811.mroafbnrrnb77qki@kafai-mbp.dhcp.thefacebook.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <750269bb-0b72-9fd9-bfeb-768213c8618a@iogearbox.net>
Date:   Wed, 30 Sep 2020 09:58:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200930064811.mroafbnrrnb77qki@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25942/Tue Sep 29 15:56:33 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/30/20 8:48 AM, Martin KaFai Lau wrote:
> On Tue, Sep 29, 2020 at 11:23:03PM +0200, Daniel Borkmann wrote:
[...]
> 
>> +/* Internal, non-exposed redirect flags. */
>> +enum {
>> +	BPF_F_NEIGH = (1ULL << 1),
>> +};
> It will be useful to ensure the future "flags" of BPF_FUNC_redirect
> will not overlap with this.  May be a BUILD_BUG_ON?

I was thinking about this as well, but didn't go for it since typically this would
mean that we need to add a mask of all flags for redirect helper in uapi right next
to where we define BPF_F_INGRESS such that people don't forget to update the mask
whenever they extend the flags there in order for the BUILD_BUG_ON() assertion to be
actually effective (see also RTAX_FEATURE_MASK vs DST_FEATURE_MASK). If the mask sits
in a different location, then developers might forget to update, it might slip through
review (since not included in diff) and the build failure doesn't trigger. So far we
have avoided to extend bpf uapi in such way. That was basically my rationale, another
option could be to just add a comment in the enum right underneath BPF_F_INGRESS that
the (1ULL << 1) bit is currently kernel-internal.

> Others LGTM.
> 
> Acked-by: Martin KaFai Lau <kafai@fb.com>

Thanks!

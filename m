Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B90034FBB
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 20:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbfFDSSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 14:18:13 -0400
Received: from mga06.intel.com ([134.134.136.31]:13341 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbfFDSSM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 14:18:12 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jun 2019 11:18:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,550,1549958400"; 
   d="scan'208";a="181646409"
Received: from unknown (HELO btopel-mobl.ger.intel.com) ([10.255.41.153])
  by fmsmga002.fm.intel.com with ESMTP; 04 Jun 2019 11:18:09 -0700
Subject: Re: [PATCH v4 bpf-next 1/2] bpf: Allow bpf_map_lookup_elem() on an
 xskmap
To:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net
References: <20190603163852.2535150-1-jonathan.lemon@gmail.com>
 <20190603163852.2535150-2-jonathan.lemon@gmail.com>
 <20190604184306.362d9d8e@carbon>
 <87399C88-4388-4857-AD77-E98527DEFDA4@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <d45c6fe7-853f-1113-62db-b8da68078940@intel.com>
Date:   Tue, 4 Jun 2019 20:18:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <87399C88-4388-4857-AD77-E98527DEFDA4@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-06-04 19:25, Jonathan Lemon wrote:
> On 4 Jun 2019, at 9:43, Jesper Dangaard Brouer wrote:
> 
>> On Mon, 3 Jun 2019 09:38:51 -0700
>> Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>>
>>> Currently, the AF_XDP code uses a separate map in order to
>>> determine if an xsk is bound to a queue.  Instead of doing this,
>>> have bpf_map_lookup_elem() return the queue_id, as a way of
>>> indicating that there is a valid entry at the map index.
>>
>> Just a reminder, that once we choose a return value, there the
>> queue_id, then it basically becomes UAPI, and we cannot change it.
> 
> Yes - Alexei initially wanted to return the sk_cookie instead, but
> that's 64 bits and opens up a whole other can of worms.
>

Hmm, what other info would be useful? ifindex? Or going the the
other way, with read-only and just returning boolean?

> 
>> Can we somehow use BTF to allow us to extend this later?
>>
>> I was also going to point out that, you cannot return a direct pointer
>> to queue_id, as BPF-prog side can modify this... but Daniel already
>> pointed this out.
>

Ugh, good thing Daniel found this!


Björn

> So, I see three solutions here (for this and Toke's patchset also,
> which is encountering the same problem).
> 
> 1) add a scratch register (Toke's approach)
> 2) add a PTR_TO_<type>, which has the access checked.  This is the most
>     flexible approach, but does seem a bit overkill at the moment.
> 3) add another helper function, say, bpf_map_elem_present() which just
>     returns a boolean value indicating whether there is a valid map entry
>     or not.
> 
> I was starting to do 2), but wanted to get some more feedback first.
> 

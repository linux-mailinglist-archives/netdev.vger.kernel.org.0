Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70DEA121035
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 17:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbfLPQzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 11:55:36 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:39998 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbfLPQzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 11:55:36 -0500
Received: by mail-pj1-f68.google.com with SMTP id s35so3228389pjb.7
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 08:55:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=RZ3FMFMV6y5ZTjXPQGyK71brBjPOnI5E8F5urgggObY=;
        b=CriwyJW8no61Qqq/BRXcxKIGkQlUFjI8xXuvFz6O6+6SOpG8o1gMxSJmxR8IMnmQaZ
         kRws9XbP7czyQ1SxhgF0Oa1Tqffg5CI1dUbySTnR5HOETNo6B4QnnnCH23Ve16vASaUq
         mvGpF1gQDROEF0DdLIPL97Dly+G+kwwJlTyiyHQlEuFJkDnwmhGdyfttAeJJtS79Be9W
         HwkAK2iCAYWLnoUrlKXv7BrQjFhLX2RMvEHMl/VBG7XHIPrxpZRmZBeafHdLCqmKlGo1
         oT+kgWF04uWjsaRCDm6MNttJzyovoqabVr2IMoEDOYWDl1YqdphROAa7SUJ9dQytEnDq
         Vu6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RZ3FMFMV6y5ZTjXPQGyK71brBjPOnI5E8F5urgggObY=;
        b=FU2+FLISJI/3zO+VT0H8sTOSDQJnOv7RMEM+ydpU+f6cqbWnn4ImQFN17zvH5brNxt
         02IRn9yNbNycwEsuxx3kAszsj/R8GUclltYQyq3tbr/Vmcl+6IUFUCQYNDZkZUImt5uh
         +y4O5l83lhdYq2B2UGqC0UXdcIWcTwbSt2RobtOigzzoTIrsqvSdMvg34NSGZeOgCooB
         WPG9lka+MoA0QQnusi8OngEc8Bv+p/sscKg6XNtSFMGQLVq9hw/F3S4z015ruQHNuHmZ
         lUON7exRIprn5L36FvISyVnYFieyib6pWa4vLOL1LdMwffwROwLnVouxL5VKMQ63aCW7
         qnsQ==
X-Gm-Message-State: APjAAAVwjmxdffVGgMXgfEXoVcBXX5rIYSnXkZt9oE9IQDJM3W1NeAI8
        A/O/vjXS0tWS26zXHttmSlM=
X-Google-Smtp-Source: APXvYqybcxiZem2ukWyW+P89sTBBeEPrS1ooYagqg/Azx3xAMDui6ZKy8ywbKfcFWdvcXsMqC1Hz9A==
X-Received: by 2002:a17:902:265:: with SMTP id 92mr16850815plc.313.1576515335810;
        Mon, 16 Dec 2019 08:55:35 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id d22sm22891673pgg.52.2019.12.16.08.55.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 08:55:35 -0800 (PST)
Subject: Re: [MPTCP] Re: [PATCH net-next 09/11] tcp: Check for filled TCP
 option space before SACK
To:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org, mptcp@lists.01.org
References: <20191213230022.28144-1-mathew.j.martineau@linux.intel.com>
 <20191213230022.28144-10-mathew.j.martineau@linux.intel.com>
 <47545b88-94db-e9cd-2f9f-2c6d665246e2@gmail.com>
 <b9833b748f61c043a2827daee060d4ad4171996e.camel@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <d5b3a6ed-fb57-e74d-ef63-ebc4ce49e4b7@gmail.com>
Date:   Mon, 16 Dec 2019 08:55:34 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <b9833b748f61c043a2827daee060d4ad4171996e.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/16/19 4:52 AM, Paolo Abeni wrote:

> Thank you for the feedback!
> 
> Unfortunatelly, the above commit is not enough when MPTCP is enabled,
> as, without this patch, we can reach the following code:
> 
> 		const unsigned int remaining = MAX_TCP_OPTION_SPACE - size;
> 		opts->num_sack_blocks =
> 			min_t(unsigned int, eff_sacks,
> 			      (remaining - TCPOLEN_SACK_BASE_ALIGNED) /
> 			      TCPOLEN_SACK_PERBLOCK);
> 
> with 'size == MAX_TCP_OPTION_SPACE' and num_sack_blocks will be
> miscalculated. So we need 'fix' but only for MPTCP/when MPTCP is
> enabled. Still ok for a -net commit?
> 

Does it means MPTCP flows can not use SACK at all ? That would be very bad.

What is the size of MPTCP options ?


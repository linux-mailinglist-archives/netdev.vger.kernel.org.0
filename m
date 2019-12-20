Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45C1D12809A
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 17:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbfLTQ0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 11:26:09 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55285 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727181AbfLTQ0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 11:26:09 -0500
Received: by mail-wm1-f66.google.com with SMTP id b19so9518469wmj.4
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 08:26:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=43fF8szyREsowHj6iqqGUWPy3IW+CVfJ2/YQpQCrFzs=;
        b=M/8l8mzjJBdTVTMiGgqMJ4ZkdK/wd6el8ibJXdlLRI9DMND1Ryt1erRd+adhtn70C8
         y+rgqY1a1vtz81Qg4cFdJwLS/sTf9Fn+/jbIKqmH4BCPPWtzaIOM1tyXbaRTS5TFOSNj
         FPNCTZAvP8oaSt5oHO0BaK6GkaUFuMG06fygtIxQfTZ1V004VsWPF7MQRvKBZLIfdp71
         Z3xlmEJJQY9IMzMCmT9KBAXSQEFXMcqBFtFvX6rW30H5bXhkMID7Jbr/1XPKgbuBuFBg
         VCGKhEkDt5hS8+UyKJPA8LepuiQR7wOJyh0FaAGNyFrpJmYcEnbjS4NmsjPE4bP4REjF
         7UwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=43fF8szyREsowHj6iqqGUWPy3IW+CVfJ2/YQpQCrFzs=;
        b=SGfGmOSBkDrpXwGVcMqMbRL+O23jMajj2O+q9p7jNRcfucw8gLoabfjrQkQYRa64el
         30BXe8Y/Blxs+r7D9OrS3a4AsLqM5F9y5+GeA7vOP7c0AKXIl7xPeXWgBBUdXGkoFnYO
         U6b4eyaOL79iQdMYoIXFPDd74rdfL3K4DGFCforQRGa6wCNm6jJpeAGLq1vNZgb2WRbi
         QjcSspAZJHa0b6Lzs6uTvdGMg0VOYmNY9Sxeu5xXLNWtB1JVjP76B++Cb0jZl4PO8jdB
         fkxczC6w3WaWZ4uWlLewD1LnjNCsyAjYVXzZs/Bol6FI7gjxF+qZiIYPnMhWAFDAMDXM
         ibCA==
X-Gm-Message-State: APjAAAUPWA30XWSFy+4gTPapY28DKl69jDcUammQhIVd3iPc5Nkphr9D
        8O9Az8f0XS26dR1L+5t8d7Q=
X-Google-Smtp-Source: APXvYqyLrqB01bu8V7zgX88zc1av6jDcwct8T2ImiIZtcEic8dltX1Ohs2cVOVEHm1o5xUtFveZkhg==
X-Received: by 2002:a1c:3dc3:: with SMTP id k186mr16812555wma.95.1576859167804;
        Fri, 20 Dec 2019 08:26:07 -0800 (PST)
Received: from [192.168.8.147] (72.173.185.81.rev.sfr.net. [81.185.173.72])
        by smtp.gmail.com with ESMTPSA id s16sm10398518wrn.78.2019.12.20.08.26.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2019 08:26:07 -0800 (PST)
Subject: Re: [PATCH net-next v5 05/11] tcp, ulp: Add clone operation to
 tcp_ulp_ops
To:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org, mptcp@lists.01.org
References: <20191219223434.19722-1-mathew.j.martineau@linux.intel.com>
 <20191219223434.19722-6-mathew.j.martineau@linux.intel.com>
 <de3e37b0-f3ff-c5d0-9a38-890ce04916c7@gmail.com>
 <1563cacb2fb2f5c59bedc7a33667586d4c3ec6c5.camel@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <2c5e98ae-f563-f6b4-b09c-ef0e0a12ffa5@gmail.com>
Date:   Fri, 20 Dec 2019 08:26:06 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1563cacb2fb2f5c59bedc7a33667586d4c3ec6c5.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/20/19 8:21 AM, Paolo Abeni wrote:
> On Fri, 2019-12-20 at 07:26 -0800, Eric Dumazet wrote:
>>
>> On 12/19/19 2:34 PM, Mat Martineau wrote:
>>> If ULP is used on a listening socket, icsk_ulp_ops and icsk_ulp_data are
>>> copied when the listener is cloned. Sometimes the clone is immediately
>>> deleted, which will invoke the release op on the clone and likely
>>> corrupt the listening socket's icsk_ulp_data.
>>>
>>> The clone operation is invoked immediately after the clone is copied and
>>> gives the ULP type an opportunity to set up the clone socket and its
>>> icsk_ulp_data.
>>>
>>
>> Since the method is void, this means no error can happen.
>>
>> For example we do not intend to attempt a memory allocation ?
> 
> if the MPTCP ULP clone fails, we fallback to plain TCP (the 'is_mptcp'
> flag cleared on the tcp 'struct sock'), so we don't have an error
> return code there.
> 
> If we change the 'clone' signature, than the only in-kernel user will
> always return 0, would that be ok?

I guess you could simply add more comments in the changelog for the time being.

I was trying to make sure we would not have later another patch changing
the signature.

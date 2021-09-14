Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1159940B076
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 16:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233550AbhINOWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 10:22:08 -0400
Received: from mail-ej1-f44.google.com ([209.85.218.44]:43683 "EHLO
        mail-ej1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233309AbhINOWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 10:22:07 -0400
Received: by mail-ej1-f44.google.com with SMTP id qq21so23428765ejb.10;
        Tue, 14 Sep 2021 07:20:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XGnqHlTada8kt7JMhcSG+hhKlGg+XdQqdPMlXWGpXXk=;
        b=UKbDQZcSGzJ10aODs5ZBIs0cd7mwnRG8ZxwogXG2H+vXJMjtCi3PE1fyWINfJxf4Dy
         vTHbLdi+RBpn6lrDvqaU080SosTRoFuW+caudgOXS27bbvH87aJQW19VjQlk46YKyOcb
         MainFBReCFEuUUDQnuhsOT5L2uhQHnzmP2Gqi71a8AqiOyYW6CLK1rLpMML9SIJdBJSO
         K8q0SQvdDIHOeGXhlWrmeyKPe83J+gR7MjZ5l3tCWFdYMPDv705O2fXhMTPK4Z3cTbvv
         zGQkjog09ZhH2Wrsd3tCK4MtnOSzng7tQIgjX9jb+Hznso2/w0bEJZmj1EamtIrTnZel
         iljQ==
X-Gm-Message-State: AOAM532U0kvPEF0WEsadEkJbYiyEuXnXhEZfb14ysTp1dM+tWlEqCYBu
        hFXlP4vscy9KJSts1h0BRdx2BNYPXhc=
X-Google-Smtp-Source: ABdhPJxDbmedGBT9r9JVf+HeI3wIhKhIVhW8I7W0RqxIT+ZyOY5isY7jp3mSeNz41l/EqPc/TJjXBg==
X-Received: by 2002:a17:906:12c8:: with SMTP id l8mr18656289ejb.515.1631629248403;
        Tue, 14 Sep 2021 07:20:48 -0700 (PDT)
Received: from [10.100.102.14] (109-186-240-23.bb.netvision.net.il. [109.186.240.23])
        by smtp.gmail.com with ESMTPSA id h10sm5004262ede.28.2021.09.14.07.20.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 07:20:47 -0700 (PDT)
Subject: Re: [RFC v1] nvme-tcp: enable linger socket option on shutdown
To:     Daniel Wagner <dwagner@suse.de>,
        Christoph Hellwig <hch@infradead.org>
Cc:     linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20210903121757.140357-1-dwagner@suse.de>
 <YTXKHOfnuf+urV1D@infradead.org> <20210914084613.75qykjxweh66mdpx@carbon>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <a79bf503-b1d5-8d18-5f02-c63e665e2e07@grimberg.me>
Date:   Tue, 14 Sep 2021 17:20:46 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210914084613.75qykjxweh66mdpx@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>>> When the no linger is set, the networking stack sends FIN followed by
>>> RST immediately when shutting down the socket. By enabling linger when
>>> shutting down we have a proper shutdown sequence on the wire.
>>>
>>> Signed-off-by: Daniel Wagner <dwagner@suse.de>
>>> ---
>>> The current shutdown sequence on the wire is a bit harsh and
>>> doesn't let the remote host to react. I suppose we should
>>> introduce a short (how long?) linger pause when shutting down
>>> the connection. Thoughs?
>>
>> Why?  I'm not really a TCP expert, but why is this different from
>> say iSCSI or NBD?
> 
> I am also no TCP expert. Adding netdev to Cc.
> 
> During testing the nvme-tcp subsystem by one of our partners we observed
> this. Maybe this is perfectly fine. Just as I said it looks a bit weird
> that a proper shutdown of the connection a RST is send out right after
> the FIN.

The point here is that when we close the connection we may have inflight
requests that we already failed to upper layers and we don't want them
to get through as we proceed to error handling. This is why we want the
socket to go away asap.

> No idea how iSCSI or NBD handles this. I'll check.

iSCSI does the same thing in essence (with a minor variation because in
iscsi we have a logout message which we don't have in nvme).

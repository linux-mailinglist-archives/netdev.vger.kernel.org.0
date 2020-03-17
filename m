Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B60ED1888C8
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 16:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgCQPNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 11:13:19 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37415 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbgCQPNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 11:13:19 -0400
Received: by mail-wr1-f67.google.com with SMTP id 6so26161731wre.4
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 08:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SQJE9sADvhXcE14Yt/xn2EtDKEixD4cbIAzbKpS0x+g=;
        b=TAEwmChFqOKcPRTJn14Wnusk61bFMTyzNE3pLO9D7wqOnrnmKOsg7Kw9xBLdo9acH/
         L+mSl55/hH2f0DcE8NUj0SU5/dMOTcuR0crRLL3FZ3FXyvUGZv3bCAydrpPfGuEg6HIF
         YStRHtGxFA/Curp86TVkLnPDXFYuazD5d3ncluVVBEF5xoL24DjaKbbYCQNGAlmzXHSl
         BBclqM1U0U5w1uhfdMNtAli/eeYNNV+ISWHoYD5BmxTXIRAUNdgoxh8acUZJm2XGl/bF
         PgaXrgUO014Z5Ul8e9b64UkDli0JW+ttNjQgiJu5Wl1PcGaiRqXC5MY4j2ReF7q2pUuc
         +c9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SQJE9sADvhXcE14Yt/xn2EtDKEixD4cbIAzbKpS0x+g=;
        b=WLUYujCG/r0JAMRdTr1MZKPHg/E5LTSIsO6k0u278vtRq9WjRzKg5iPHv+pST6ZJ+5
         9WhH0Wm/ov2Mre+5TVK+1X9/6fizD64RJxr3zwlMq+O6ThVN3HxWxFyecySIXkV7rRn1
         vcS9F6D/lWAHOATIa9JCgl/XI3jsdJvDXQxz3TmGd4VuO6AoWSMS9kg11G4U4Xqeec9c
         MsOF9JM9U6VSH2/fRlvn24aoTJmZ9Km91W14btMXBHwmxIumsAAUeZnQw5eWX2MZennB
         FpgB1IRnxq+T48ckx8EgHIMEQw26I6WEi2W/8pJMyj/E8vLPqd5kC+h9PlAW39KOHpar
         twgw==
X-Gm-Message-State: ANhLgQ1tqZn4UGIWUr9fgT+ZRx9m35YZnnc0q1t5cyV+y2y+qIWWzdam
        ifiQPJ9+KyOqMf73j9mUUUOlY9kKvI0Emw==
X-Google-Smtp-Source: ADFU+vupe7y8qvpz3JbZ1Nf+IbNQfjMaq9qsXQCco2r3OABUZvtpaRRiHfARW/uQCPS49U4DIqI11A==
X-Received: by 2002:a5d:490e:: with SMTP id x14mr7069211wrq.58.1584457997149;
        Tue, 17 Mar 2020 08:13:17 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net (81.243-247-81.adsl-dyn.isp.belgacom.be. [81.247.243.81])
        by smtp.gmail.com with ESMTPSA id v2sm192514wme.2.2020.03.17.08.13.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Mar 2020 08:13:16 -0700 (PDT)
Subject: Re: [PATCH net-next] mptcp: move msk state update to
 subflow_syn_recv_sock()
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
References: <ca414f55f4c74190bc419815f6ac7c61313bac2a.1584456734.git.pabeni@redhat.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <0db35d4e-bbc3-703c-5b18-3fab6e954f01@tessares.net>
Date:   Tue, 17 Mar 2020 16:13:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <ca414f55f4c74190bc419815f6ac7c61313bac2a.1584456734.git.pabeni@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/03/2020 15:53, Paolo Abeni wrote:
> After commit 58b09919626b ("mptcp: create msk early"), the
> msk socket is already available at subflow_syn_recv_sock()
> time. Let's move there the state update, to mirror more
> closely the first subflow state.
> 
> The above will also help multiple subflow supports.
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

LGTM, Thanks Paolo!

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>

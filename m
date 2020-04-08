Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E356D1A19ED
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 04:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbgDHCZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 22:25:20 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33908 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbgDHCZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 22:25:19 -0400
Received: by mail-pg1-f193.google.com with SMTP id l14so2664374pgb.1
        for <netdev@vger.kernel.org>; Tue, 07 Apr 2020 19:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8YakeIytkCqdHsA7rZz1DKZmmB2+FFdVVFL33CNj1L0=;
        b=Mr+jmsXpQfi/mJzy+2EkycfrUdnhUWgfbYvF4YE1VRvqyqWUqUD0CAAUNluaH9xwTq
         I7lT0MhkfVoUKxiuvAJ5Pw8bVvxU0Ih6h/IdGpMAtz2RUsOFpYVFQasvGHmvCI9R1HF5
         6JoA86zxqv3HsPPiQlQaxyx3BMQPzJwuK+QCMYHHrdP63zySCxyFiDdHqO3cLDukrDxQ
         Oto++2ctjS0zDb1+a/ByMx1E7ac9QSfaieerXdaZaWT/Tv7/cbNxzZKIfkqhfDPo01Q8
         kJMvEFXK/rto3F3zSswpKiYDpDVefcLeo5NYgeXKLSuyiZWZSI/rdv+0g0hB40WQlFer
         ZRyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8YakeIytkCqdHsA7rZz1DKZmmB2+FFdVVFL33CNj1L0=;
        b=cdOMJh5KFOlNAAYaUH2QHocbawzcDpD1h6YOPPI84hs+qjmzdv6U4tV2RDko/izXHT
         cusKABv76BgHe554X5V54890yirnDwG+PVASzxRBMfEJNM6K1Sbi24UkEULH8P8bBkFQ
         XsG84QWolCiQW0CtMA0PJfff93j9gJF9SkqpA7Tq+zeM49ooNoqYUKxDiP7HHEpMnwCE
         wkOpzsoYQWMrNAWpmAsYn9dXbrwEgXo5bo/RgTH2Sbo4BqgTmAtfJTw0ovJZmorP7Ncq
         OgAD5foRcs3qg3SzxebCmoOLoukSSwEoS3zv+cYxYt6RD/w2jyFOqtLNaaahWpxF+v3O
         Jvyw==
X-Gm-Message-State: AGi0Pubf3R3yTHS0q5EFfH8ne+mg4RiDP1c6khWPeWo2/v8wEiDqUvBr
        r/AcCNC1PchEJgEcmyLnAX+c7fZW
X-Google-Smtp-Source: APiQypL6VdDS+QFl5RvJkV7nJriuiJr9LDZN0HFfdtzbavKpLrlXwC/lf+htlusZVSAQG07Ucj2hag==
X-Received: by 2002:a62:164a:: with SMTP id 71mr632683pfw.273.1586312718894;
        Tue, 07 Apr 2020 19:25:18 -0700 (PDT)
Received: from [0.0.0.0] ([2001:19f0:8001:1c6b:5400:2ff:fe92:fb44])
        by smtp.googlemail.com with ESMTPSA id s61sm3017792pjd.33.2020.04.07.19.25.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Apr 2020 19:25:18 -0700 (PDT)
Subject: Re: [PATCH net 2/2] net/rds: Fix MR reference counting problem
To:     santosh.shilimkar@oracle.com,
        Ka-Cheong Poon <ka-cheong.poon@oracle.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, rds-devel@oss.oracle.com
References: <4b96ea99c3f0ccd5cc0683a5c944a1c4da41cc38.1586275373.git.ka-cheong.poon@oracle.com>
 <a99e79aa8515e4b52ced83447122fbd260104f0f.1586275373.git.ka-cheong.poon@oracle.com>
 <96f17f7d-365c-32ec-2efe-a6a5d9d306b7@oracle.com>
From:   zerons <sironhide0null@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <e1853439-fe73-14d1-a57c-1a67341a7f8a@gmail.com>
Date:   Wed, 8 Apr 2020 10:25:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <96f17f7d-365c-32ec-2efe-a6a5d9d306b7@oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/8/20 03:30, santosh.shilimkar@oracle.com wrote:
> On 4/7/20 9:08 AM, Ka-Cheong Poon wrote:
>> In rds_free_mr(), it calls rds_destroy_mr(mr) directly.  But this
>> defeats the purpose of reference counting and makes MR free handling
>> impossible.  It means that holding a reference does not guarantee that
>> it is safe to access some fields.  For example, In
>> rds_cmsg_rdma_dest(), it increases the ref count, unlocks and then
>> calls mr->r_trans->sync_mr().  But if rds_free_mr() (and
>> rds_destroy_mr()) is called in between (there is no lock preventing
>> this to happen), r_trans_private is set to NULL, causing a panic.
>> Similar issue is in rds_rdma_unuse().
>>
>> Reported-by: zerons <sironhide0null@gmail.com>
>> Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
>> ---
> Thanks for getting this out on the list.
> 
> Hi zerons,
> Can you please review it and see it addresses your concern ?
> 

Yes, the MR gets freed only when the ref count decreases to zero does
address my concern. I think it make the logic cleaner as well. Fantastic!

Regards,
zerons

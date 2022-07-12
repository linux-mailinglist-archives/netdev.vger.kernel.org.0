Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C86C5710CB
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 05:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbiGLDYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 23:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbiGLDYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 23:24:42 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F09BF4C;
        Mon, 11 Jul 2022 20:24:41 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id r6so3688084plg.3;
        Mon, 11 Jul 2022 20:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=OSSM+MSc4W5cafWf+JO3va4gEwypg/7RgvRHGJ59Jpo=;
        b=cCy/01FQWPWE0Tve4CkNo+KegP5fhGB6qXq6P2tD0FzJKd4oZo17AfG4456RFmtmgZ
         llZqHxUEDkBN+7zbMzYbL7TDB6sCHHptVUDTkXJ6wNGMZ+dSSVxKEuFFd7ERQSlPCysV
         mn5zRc/1HW48lyxF4OrPBZICtb1xWe5Gvd4exxEphMclslZPNbv/KyFqB9fd4S1AJpdF
         3eeAy8FGRtUZwQOnl9sRfdRfVDSriQmFd2QOmTp4A81H03tSis+WLtQHhfc6DB7bNajl
         eKohariMPEbSsWNWZUrjRqHcv7sKVGCX/t8E7wSTvW2KsXAgItTIzURKgsbNX/0g/YO/
         TeQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OSSM+MSc4W5cafWf+JO3va4gEwypg/7RgvRHGJ59Jpo=;
        b=xlQ+I+LuKZyKsRuTDsdwe/7EySV4guBy0LILaACl43RnYjSuDKPeamNSc9qnUCsS5b
         CnhaRTibdW6/RfOYOP20dof8LuNBPoI+BYe6ujvt8pFt+WrNO2+xfqEBFoVTo1qX4QwB
         3CIlgyoBBDSsZShCyM2EH6+TdmB+kmtOL+dvtOU8ePel0smhV0HMi06eXi4EPHzNWddL
         S6ZZgXABYOU9YoGFbcb8cYLffZtWL+3EndET1qWC89L5B8gAOfTzZfsAqByHOMF4XQ8y
         olUriIl2bgh/gs47UAiAwka0S2aQeQ9Ky6itNmwArNKgf2Yyr7RKxfSUm9RhFSZptNNj
         tBjw==
X-Gm-Message-State: AJIora9EoEMkVi2USAqxOJv0Rwfcx5CSgfo83GjTODyKm5M4rOVweEyB
        jnnxw7a0e5UwMNRXOoNxy1I=
X-Google-Smtp-Source: AGRyM1sdRMSgXogG7rND064GIevAmoTe6xOv9PP2MJqV6el9DYNm6hmg6Vh7A5r3FZQDl+wbbs33IQ==
X-Received: by 2002:a17:903:240e:b0:168:ea13:f9e0 with SMTP id e14-20020a170903240e00b00168ea13f9e0mr21885579plo.6.1657596281194;
        Mon, 11 Jul 2022 20:24:41 -0700 (PDT)
Received: from [192.168.50.247] ([129.227.148.126])
        by smtp.gmail.com with ESMTPSA id g28-20020aa796bc000000b0052a75004c51sm5701024pfk.146.2022.07.11.20.24.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 20:24:40 -0700 (PDT)
Message-ID: <f68df7cf-4b72-4c01-9492-103fa67c5e99@gmail.com>
Date:   Tue, 12 Jul 2022 11:24:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] net: 9p: fix possible refcount leak in p9_read_work() and
 recv_done()
Content-Language: en-US
To:     asmadeus@codewreck.org
Cc:     ericvh@gmail.com, lucho@ionkov.net, linux_oss@crudebyte.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, tomasbortoli@gmail.com,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220711065907.23105-1-hbh25y@gmail.com>
 <YsvTvalrwd4bxO75@codewreck.org>
From:   Hangyu Hua <hbh25y@gmail.com>
In-Reply-To: <YsvTvalrwd4bxO75@codewreck.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/7/11 15:39, asmadeus@codewreck.org wrote:
> Hangyu Hua wrote on Mon, Jul 11, 2022 at 02:59:07PM +0800:
>> A ref got in p9_tag_lookup needs to be put when functions enter the
>> error path.
>>
>> Fix this by adding p9_req_put in error path.
> 
> I wish it was that simple.
> 
> Did you actually observe a leak? >
>> diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
>> index 8f8f95e39b03..c4ccb7b9e1bf 100644
>> --- a/net/9p/trans_fd.c
>> +++ b/net/9p/trans_fd.c
>> @@ -343,6 +343,7 @@ static void p9_read_work(struct work_struct *work)
>>   			p9_debug(P9_DEBUG_ERROR,
>>   				 "No recv fcall for tag %d (req %p), disconnecting!\n",
>>   				 m->rc.tag, m->rreq);
>> +			p9_req_put(m->rreq);
>>   			m->rreq = NULL;
>>   			err = -EIO;
>>   			goto error;
>> @@ -372,6 +373,8 @@ static void p9_read_work(struct work_struct *work)
>>   				 "Request tag %d errored out while we were reading the reply\n",
>>   				 m->rc.tag);
>>   			err = -EIO;
>> +			p9_req_put(m->rreq);
>> +			m->rreq = NULL;
>>   			goto error;
>>   		}
>>   		spin_unlock(&m->client->lock);
> 
> 
> for tcp, we still have that request in m->req_list, so we should be
> calling p9_client_cb which will do the p9_req_put in p9_conn_cancel.
> 
> If you do it here, you'll get a refcount overflow and use after free.
> 


That's a little weird. If you are right, the three return paths of this 
function are inconsistent with the handling of refcount.

static void p9_read_work(struct work_struct *work)
{
...
	if ((m->rreq) && (m->rc.offset == m->rc.capacity)) {
		p9_debug(P9_DEBUG_TRANS, "got new packet\n");
		m->rreq->rc.size = m->rc.offset;
		spin_lock(&m->client->lock);
		if (m->rreq->status == REQ_STATUS_SENT) {
			list_del(&m->rreq->req_list);
			p9_client_cb(m->client, m->rreq, REQ_STATUS_RCVD);	<---- [1]
		} else if (m->rreq->status == REQ_STATUS_FLSHD) {
			/* Ignore replies associated with a cancelled request. */
			p9_debug(P9_DEBUG_TRANS,
				 "Ignore replies associated with a cancelled request\n");	<---- [2]
		} else {
			spin_unlock(&m->client->lock);
			p9_debug(P9_DEBUG_ERROR,
				 "Request tag %d errored out while we were reading the reply\n",
				 m->rc.tag);
			err = -EIO;
			goto error;	<---- [3]
		}
		spin_unlock(&m->client->lock);
		m->rc.sdata = NULL;
		m->rc.offset = 0;
		m->rc.capacity = 0;
		p9_req_put(m->rreq);	<---- [4]
		m->rreq = NULL;
	}
...
error:
	p9_conn_cancel(m, err);		<---- [5]
	clear_bit(Rworksched, &m->wsched);
}

There are three return paths here, [1] and [2] and [3].

[1]: m->rreq will be put twice in [1] and [4]. And m->rreq will be 
deleted from the m->req_list in [1].

[2]: m->rreq will be put in [4]. And m->rreq will not be deleted from 
m->req_list.

[3]: m->rreq will be put in [5]. And m->rreq will be deleted from the 
m->req_list in [5].

If p9_tag_lookup keep the refcount of req which is in m->req_list. There 
will be a double put in return path [1] and a potential UAF in return 
path [2]. And this also means a req in m->req_list without getting 
refcount before p9_tag_lookup.

static void p9_write_work(struct work_struct *work)
{
...
		list_move_tail(&req->req_list, &m->req_list);

		m->wbuf = req->tc.sdata;
		m->wsize = req->tc.size;
		m->wpos = 0;
		p9_req_get(req);
...
}

But if you check out p9_write_work, a refcount already get after 
list_move_tail. We don't need to rely on p9_tag_lookup to keep a list's 
refcount. Whatsmore, code comments in p9_tag_alloc also proves that the 
refcount get by p9_tag_lookup is a temporary refcount.

So i still think there may be a refcount leak.

>> diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
>> index 88e563826674..82b5d6894ee2 100644
>> --- a/net/9p/trans_rdma.c
>> +++ b/net/9p/trans_rdma.c
>> @@ -317,6 +317,7 @@ recv_done(struct ib_cq *cq, struct ib_wc *wc)
>>   	/* Check that we have not yet received a reply for this request.
>>   	 */
>>   	if (unlikely(req->rc.sdata)) {
>> +		p9_req_put(req);
>>   		pr_err("Duplicate reply for request %d", tag);
>>   		goto err_out;
>>   	}
> 
> This one isn't as clear cut, I see that they put the client in a
> FLUSHING state but nothing seems to acton on it... But if this happens
> we're already in the use after free realm -- it means rc.sdata was
> already set so the other thread could be calling p9_client_cb anytime if
> it already hasn't, and yet another thread will then do the final ref put
> and free this.
> We shouldn't free this here as that would also be an overflow. The best
> possible thing to do at this point is just to stop using that pointer.
>

But p9_tag_lookup have a lock inside. Doesn't this mean p9_tag_lookup 
won't return a freed req? Otherwise we should fix the lock to avoid 
falling into the use after free realm.

Thanks,
Hangyu
> 
> If you actually run into a problem with these refcounts (should get a
> warning on umount that something didn't get freed) then by all mean
> let's look further into it, but please don't send such patches without
> testing the error paths you're "fixing" -- I'm pretty sure a reproducer
> to hit these paths would bark errors in dmesg as refcount has an
> overflow check.
> 
> --
> Dominique

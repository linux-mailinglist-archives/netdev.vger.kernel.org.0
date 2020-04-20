Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCE011B0194
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 08:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbgDTGbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 02:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725812AbgDTGbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 02:31:46 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DFC1C061A0C
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 23:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=WBcWIkwTHEisJVMlTAFPCRZjwW+7cuSVJj2Bd+JVLNQ=; b=n0lj3t2g8ngF4sP23cFyqG9ZAD
        xmTlhvOal/54dU8DQQKYrXDiaJcFv6U5gyuzveSVNidg8ky+fMmb8dEP7mwQpad395DWAZNbS10tw
        5o8HZWiFy4FQzyerD/bzj4384EKtkmw8Gddaid0FGW0XecuB57BnhHyynAggyTevCKjeC+9U7DDyx
        W71ZmKnXdIHMB9uzbso7LGCoLdCkYSRebPTnLxg7tUoe/jnxsrlumcIud4eEgz+pRwkN5+EcwzLlT
        e24fu1ocZWDUNTtiWY2Rwa/VaURs2NCyORX2Q/XNQu18/YEM9rq+YArsDvdGKiviZLIMs/gY63zVt
        C6Ab798Q==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jQPxz-0000Ry-AH; Mon, 20 Apr 2020 06:31:39 +0000
Subject: =?UTF-8?B?UmU6IGRyaXZlcnPvvJogdGFyZ2V077yaIGlzY3NpOiBjeGdiaXQ6IGlz?=
 =?UTF-8?Q?_there_exist_a_memleak_in_cxgbit=5fcreate=5fserver4=3f?=
To:     Zhiyun Qian <zhiyunq@cs.ucr.edu>,
        =?UTF-8?B?5piT5p6X?= <yilin@iie.ac.cn>
Cc:     vishal@chelsio.com, "csong@cs.ucr.edu" <csong@cs.ucr.edu>,
        "yiqiuping@gmail.com" <yiqiuping@gmail.com>,
        jian liu <liujian6@iie.ac.cn>, netdev@vger.kernel.org
References: <5b93ede1.2832e.171957ca60f.Coremail.yilin@iie.ac.cn>
 <CALvgte-xH-O6GuhD94o6GR5ko2hSj0vWViR8XFAp3+fd=eJn_Q@mail.gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <a489b206-e781-c7cb-0164-c29ca0295b39@infradead.org>
Date:   Sun, 19 Apr 2020 23:31:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CALvgte-xH-O6GuhD94o6GR5ko2hSj0vWViR8XFAp3+fd=eJn_Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/19/20 11:23 PM, Zhiyun Qian wrote:
> -Zhiyun
> 
> On Mon, Apr 20, 2020 at 2:48 AM 易林 <yilin@iie.ac.cn> wrote:
>>
>> static int
>> cxgbit_create_server4(struct cxgbit_device *cdev, unsigned int stid,
>>                       struct cxgbit_np *cnp)
>> {
>>         struct sockaddr_in *sin = (struct sockaddr_in *)
>>                                    &amp;cnp-&gt;com.local_addr;
>>         int ret;
>>
>>         pr_debug("%s: dev = %s; stid = %u; sin_port = %u\n",
>>                  __func__, cdev-&gt;lldi.ports[0]-&gt;name, stid, sin-&gt;sin_port);
>>
>>         cxgbit_get_cnp(cnp);
>>         cxgbit_init_wr_wait(&amp;cnp-&gt;com.wr_wait);
>>
>>         ret = cxgb4_create_server(cdev-&gt;lldi.ports[0],
>>                                   stid, sin-&gt;sin_addr.s_addr,
>>                                   sin-&gt;sin_port, 0,
>>                                   cdev-&gt;lldi.rxq_ids[0]);
>>         if (!ret)
>>                 ret = cxgbit_wait_for_reply(cdev,
>>                                             &amp;cnp-&gt;com.wr_wait,
>>                                             0, 10, __func__);
>>         else if (ret &gt; 0)
>>                 ret = net_xmit_errno(ret);
>>         else
>>                 cxgbit_put_cnp(cnp);
>>
>>         if (ret)
>>                 pr_err("create server failed err %d stid %d laddr %pI4 lport %d\n",
>>                        ret, stid, &amp;sin-&gt;sin_addr, ntohs(sin-&gt;sin_port));
>>         return ret;
>> }
>> what if cxgb4_create_server return a &gt;0 value, the cnp reference wouldn't be released. Or, when cxgb4_create_server  return &gt;0 value, cnp has been released somewhere.
> 
> "&gt:0"? typo?
> 

Lots of html conversions of > < etc. Makes it difficult to read.

Convert &gt; to >
Convert &lt; to <

Preferably repost as readable C source code.

-- 
~Randy


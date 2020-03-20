Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 932DA18C41F
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 01:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbgCTAIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 20:08:04 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:50907 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727159AbgCTAIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 20:08:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584662883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Anb5LRo8xpBF1QOjWwn5JazocJjB3iK3v4+s87FrK8A=;
        b=UEvzJ4NbUVFJ0b37HCB8L+FhTkbAmEeDz6h72T+m4muyPzPbAWdTcAOh8U5gdLHIUQ/0hX
        /n3pX5Xv6LC0N3lA8547MbzO/cWa3Pi7ycGXaJKuxk9cgVKw/sFwxFXrFedzabgFGAcZVK
        t+UH3212IQiKDLOt0CB9C0AcAaSzEzM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-f_JiBXiuMQ2zkpAPZ_nSSw-1; Thu, 19 Mar 2020 20:08:01 -0400
X-MC-Unique: f_JiBXiuMQ2zkpAPZ_nSSw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC5D4107ACC7;
        Fri, 20 Mar 2020 00:07:58 +0000 (UTC)
Received: from llong.remote.csb (ovpn-113-139.rdu2.redhat.com [10.10.113.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8BC6719C58;
        Fri, 20 Mar 2020 00:07:55 +0000 (UTC)
Subject: Re: [PATCH v5 2/2] KEYS: Avoid false positive ENOMEM error on key
 read
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     David Howells <dhowells@redhat.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, netdev@vger.kernel.org,
        linux-afs@lists.infradead.org, Sumit Garg <sumit.garg@linaro.org>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Eric Biggers <ebiggers@google.com>,
        Chris von Recklinghausen <crecklin@redhat.com>
References: <20200318221457.1330-1-longman@redhat.com>
 <20200318221457.1330-3-longman@redhat.com>
 <20200319194650.GA24804@linux.intel.com>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <f22757ad-4d6f-ffd2-eed5-6b9bd1621b10@redhat.com>
Date:   Thu, 19 Mar 2020 20:07:55 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200319194650.GA24804@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/19/20 3:46 PM, Jarkko Sakkinen wrote:
> On Wed, Mar 18, 2020 at 06:14:57PM -0400, Waiman Long wrote:
>> +			 * It is possible, though unlikely, that the key
>> +			 * changes in between the up_read->down_read period.
>> +			 * If the key becomes longer, we will have to
>> +			 * allocate a larger buffer and redo the key read
>> +			 * again.
>> +			 */
>> +			if (!tmpbuf || unlikely(ret > tmpbuflen)) {
> Shouldn't you check that tmpbuflen stays below buflen (why else
> you had made copy of buflen otherwise)?

The check above this thunk:

if ((ret > 0) && (ret <= buflen)) {

will make sure that ret will not be larger than buflen. So tmpbuflen
will never be bigger than buflen.

Cheers,
Longman


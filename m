Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7661818E58E
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 01:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgCVAb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 20:31:29 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:57359 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727296AbgCVAb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 20:31:29 -0400
Received: from fsav303.sakura.ne.jp (fsav303.sakura.ne.jp [153.120.85.134])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 02M0VQKJ025665;
        Sun, 22 Mar 2020 09:31:26 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav303.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav303.sakura.ne.jp);
 Sun, 22 Mar 2020 09:31:26 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav303.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 02M0VLN8025536
        (version=TLSv1.2 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Sun, 22 Mar 2020 09:31:26 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Subject: Re: [PATCH v7 2/2] KEYS: Avoid false positive ENOMEM error on key
 read
To:     Waiman Long <longman@redhat.com>
Cc:     David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
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
References: <20200321184932.16579-1-longman@redhat.com>
 <20200321184932.16579-3-longman@redhat.com>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-ID: <e3d7a227-8915-5c00-cd34-fe2db7fc7121@I-love.SAKURA.ne.jp>
Date:   Sun, 22 Mar 2020 09:31:21 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200321184932.16579-3-longman@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/03/22 3:49, Waiman Long wrote:
> +	do {

> +		if (ret > key_data_len) {
> +			if (unlikely(key_data))
> +				__kvzfree(key_data, key_data_len);
> +			key_data_len = ret;
> +			continue;	/* Allocate buffer */

Excuse me, but "continue;" inside "do { ... } while (0);" means "break;"
because "while (0)" is evaluated before continuing the loop.

----------
#include <stdio.h>

int main(int argc, char *argv[])
{
        do {
                printf("step 1\n");
                if (1) {
                        printf("step 2\n");
                        continue;
                }
                printf("step 3\n");
        } while (0);
        printf("step 4\n");
        return 0;
}
----------

----------
step 1
step 2
step 4
----------

> +		}

> +	} while (0);

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55620284064
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 22:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729656AbgJEUIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 16:08:45 -0400
Received: from mail-n.franken.de ([193.175.24.27]:47585 "EHLO drew.franken.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729424AbgJEUIp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 16:08:45 -0400
Received: from [IPv6:2a02:8109:1140:c3d:20f8:a9a0:34f9:e912] (unknown [IPv6:2a02:8109:1140:c3d:20f8:a9a0:34f9:e912])
        (Authenticated sender: macmic)
        by drew.franken.de (Postfix) with ESMTPSA id 3F21871B18968;
        Mon,  5 Oct 2020 22:08:37 +0200 (CEST)
From:   Michael Tuexen <tuexen@fh-muenster.de>
Message-Id: <029F42A9-31CF-45B6-944D-912A005EE864@fh-muenster.de>
Content-Type: multipart/signed;
        boundary="Apple-Mail=_FC7559EC-7516-4B2D-A2E8-F74B41FB61BA";
        protocol="application/pkcs7-signature";
        micalg=sha-256
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH net-next 11/15] sctp: add udphdr to overhead when udp_port
 is set
Date:   Mon, 5 Oct 2020 22:08:36 +0200
In-Reply-To: <20201005190114.GL70998@localhost.localdomain>
Cc:     Xin Long <lucien.xin@gmail.com>, kernel test robot <lkp@intel.com>,
        network dev <netdev@vger.kernel.org>,
        linux-sctp@vger.kernel.org, kbuild-all@lists.01.org,
        Neil Horman <nhorman@tuxdriver.com>,
        davem <davem@davemloft.net>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
References: <7ff312f910ada8893fa4db57d341c628d1122640.1601387231.git.lucien.xin@gmail.com>
 <202009300218.2AcHEN0L-lkp@intel.com>
 <20201003040824.GG70998@localhost.localdomain>
 <CADvbK_cPX1f5jrGsKuvya7ssOFPTsG7daBCkOP-NGN9hpzf5Vw@mail.gmail.com>
 <CADvbK_eXnzjDCypRkep9JqxBFV=cMXNkSZr4nyAaMiDc1VGXJg@mail.gmail.com>
 <CADvbK_fzASk9dLbHLNtLLc+uS7hLz6nDi2CESgN55Yh-o92+rQ@mail.gmail.com>
 <20201005190114.GL70998@localhost.localdomain>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=disabled version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on mail-n.franken.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Apple-Mail=_FC7559EC-7516-4B2D-A2E8-F74B41FB61BA
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

> On 5. Oct 2020, at 21:01, Marcelo Ricardo Leitner =
<marcelo.leitner@gmail.com> wrote:
>=20
> On Sat, Oct 03, 2020 at 08:24:34PM +0800, Xin Long wrote:
>> On Sat, Oct 3, 2020 at 7:23 PM Xin Long <lucien.xin@gmail.com> wrote:
>>>=20
>>> On Sat, Oct 3, 2020 at 4:12 PM Xin Long <lucien.xin@gmail.com> =
wrote:
>>>>=20
>>>> On Sat, Oct 3, 2020 at 12:08 PM Marcelo Ricardo Leitner
>>>> <marcelo.leitner@gmail.com> wrote:
>>>>>=20
>>>>> On Wed, Sep 30, 2020 at 03:00:42AM +0800, kernel test robot wrote:
>>>>>> Hi Xin,
>>>>>>=20
>>>>>> Thank you for the patch! Yet something to improve:
>>>>>=20
>>>>> I wonder how are you planning to fix this. It is quite entangled.
>>>>> This is not performance critical. Maybe the cleanest way out is to
>>>>> move it to a .c file.
>>>>>=20
>>>>> Adding a
>>>>> #if defined(CONFIG_IP_SCTP) || defined(CONFIG_IP_SCTP_MODULE)
>>>>> in there doesn't seem good.
>>>>>=20
>>>>>>   In file included from include/net/sctp/checksum.h:27,
>>>>>>                    from net/netfilter/nf_nat_proto.c:16:
>>>>>>   include/net/sctp/sctp.h: In function 'sctp_mtu_payload':
>>>>>>>> include/net/sctp/sctp.h:583:31: error: 'struct net' has no =
member named 'sctp'; did you mean 'ct'?
>>>>>>     583 |   if (sock_net(&sp->inet.sk)->sctp.udp_port)
>>>>>>         |                               ^~~~
>>>>>>         |                               ct
>>>>>>=20
>>>> Here is actually another problem, I'm still thinking how to fix it.
>>>>=20
>>>> Now sctp_mtu_payload() returns different value depending on
>>>> net->sctp.udp_port. but net->sctp.udp_port can be changed by
>>>> "sysctl -w" anytime. so:
>=20
> Good point.
>=20
>>>>=20
>>>> In sctp_packet_config() it gets overhead/headroom by calling
>>>> sctp_mtu_payload(). When 'udp_port' is 0, it's IP+MAC header
>>>> size. Then if 'udp_port' is changed to 9899 by 'sysctl -w',
>>>> udphdr will also be added to the packet in sctp_v4_xmit(),
>>>> and later the headroom may not be enough for IP+MAC headers.
>>>>=20
>>>> I'm thinking to add sctp_sock->udp_port, and it'll be set when
>>>> the sock is created with net->udp_port. but not sure if we should
>>>> update sctp_sock->udp_port with  net->udp_port when sending =
packets?
>=20
> I don't think so,
>=20
>>> something like:
> ...
>> diff --git a/net/sctp/output.c b/net/sctp/output.c
>> index 6614c9fdc51e..c96b13ec72f4 100644
>> --- a/net/sctp/output.c
>> +++ b/net/sctp/output.c
>> @@ -91,6 +91,14 @@ void sctp_packet_config(struct sctp_packet =
*packet,
>> __u32 vtag,
>>        if (asoc) {
>>                sk =3D asoc->base.sk;
>>                sp =3D sctp_sk(sk);
>> +
>> +               if (unlikely(sp->udp_port !=3D =
sock_net(sk)->sctp.udp_port)) {
>=20
> RFC6951 has:
>=20
> 6.1.  Get or Set the Remote UDP Encapsulation Port Number
>      (SCTP_REMOTE_UDP_ENCAPS_PORT)
> ...
>   sue_assoc_id:  This parameter is ignored for one-to-one style
>      sockets.  For one-to-many style sockets, the application may fill
>      in an association identifier or SCTP_FUTURE_ASSOC for this query.
>      It is an error to use SCTP_{CURRENT|ALL}_ASSOC in sue_assoc_id.
>=20
>   sue_address:  This specifies which address is of interest.  If a
>      wildcard address is provided, it applies only to future paths.
>=20
> So I'm not seeing a reason to have a system wide knob that takes
> effect in run time like this.
> Enable, start apps, and they keep behaving as initially configured.
> Need to disable? Restart the apps/sockets.
>=20
> Thoughts?
Just note about how things are implemented in FreeBSD. This is not about
how it has to be implemented, but how it can be implemented.

The local UDP encaps port is controlled by a system wide sysctl.
sudo sysctl net.inet.sctp.udp_tunneling_port=3D9899
will use from that point on port 9899 the local encaps port. The
local encaps port can't be controlled by the application.
sudo sysctl net.inet.sctp.udp_tunneling_port=3D9900
will change this port number instantly to 9900. I don't see a
use case for this, but it is possible.
sudo sysctl net.inet.sctp.udp_tunneling_port=3D0
disables the sending and receiving of UDP encapsulated packets.

The application can only control the remote encapsulation port on
a per remote address base. This is mostly relevant for the client
side wanting to use UDP encapsulation.

Best regards
Michael
>=20
>> +                       __u16 port =3D sock_net(sk)->sctp.udp_port;
>> +
>> +                       if (!sp->udp_port || !port)
>> +                               sctp_assoc_update_frag_point(asoc);
>> +                       sp->udp_port =3D port;
>> +               }
>>        }


--Apple-Mail=_FC7559EC-7516-4B2D-A2E8-F74B41FB61BA
Content-Disposition: attachment;
	filename=smime.p7s
Content-Type: application/pkcs7-signature;
	name=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCEKow
ggUSMIID+qADAgECAgkA4wvV+K8l2YEwDQYJKoZIhvcNAQELBQAwgYIxCzAJBgNVBAYTAkRFMSsw
KQYDVQQKDCJULVN5c3RlbXMgRW50ZXJwcmlzZSBTZXJ2aWNlcyBHbWJIMR8wHQYDVQQLDBZULVN5
c3RlbXMgVHJ1c3QgQ2VudGVyMSUwIwYDVQQDDBxULVRlbGVTZWMgR2xvYmFsUm9vdCBDbGFzcyAy
MB4XDTE2MDIyMjEzMzgyMloXDTMxMDIyMjIzNTk1OVowgZUxCzAJBgNVBAYTAkRFMUUwQwYDVQQK
EzxWZXJlaW4genVyIEZvZXJkZXJ1bmcgZWluZXMgRGV1dHNjaGVuIEZvcnNjaHVuZ3NuZXR6ZXMg
ZS4gVi4xEDAOBgNVBAsTB0RGTi1QS0kxLTArBgNVBAMTJERGTi1WZXJlaW4gQ2VydGlmaWNhdGlv
biBBdXRob3JpdHkgMjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMtg1/9moUHN0vqH
l4pzq5lN6mc5WqFggEcVToyVsuXPztNXS43O+FZsFVV2B+pG/cgDRWM+cNSrVICxI5y+NyipCf8F
XRgPxJiZN7Mg9mZ4F4fCnQ7MSjLnFp2uDo0peQcAIFTcFV9Kltd4tjTTwXS1nem/wHdN6r1ZB+Ba
L2w8pQDcNb1lDY9/Mm3yWmpLYgHurDg0WUU2SQXaeMpqbVvAgWsRzNI8qIv4cRrKO+KA3Ra0Z3qL
NupOkSk9s1FcragMvp0049ENF4N1xDkesJQLEvHVaY4l9Lg9K7/AjsMeO6W/VRCrKq4Xl14zzsjz
9AkH4wKGMUZrAcUQDBHHWekCAwEAAaOCAXQwggFwMA4GA1UdDwEB/wQEAwIBBjAdBgNVHQ4EFgQU
k+PYMiba1fFKpZFK4OpL4qIMz+EwHwYDVR0jBBgwFoAUv1kgNgB5oKAia4zV8mHSuCzLgkowEgYD
VR0TAQH/BAgwBgEB/wIBAjAzBgNVHSAELDAqMA8GDSsGAQQBga0hgiwBAQQwDQYLKwYBBAGBrSGC
LB4wCAYGZ4EMAQICMEwGA1UdHwRFMEMwQaA/oD2GO2h0dHA6Ly9wa2kwMzM2LnRlbGVzZWMuZGUv
cmwvVGVsZVNlY19HbG9iYWxSb290X0NsYXNzXzIuY3JsMIGGBggrBgEFBQcBAQR6MHgwLAYIKwYB
BQUHMAGGIGh0dHA6Ly9vY3NwMDMzNi50ZWxlc2VjLmRlL29jc3ByMEgGCCsGAQUFBzAChjxodHRw
Oi8vcGtpMDMzNi50ZWxlc2VjLmRlL2NydC9UZWxlU2VjX0dsb2JhbFJvb3RfQ2xhc3NfMi5jZXIw
DQYJKoZIhvcNAQELBQADggEBAIcL/z4Cm2XIVi3WO5qYi3FP2ropqiH5Ri71sqQPrhE4eTizDnS6
dl2e6BiClmLbTDPo3flq3zK9LExHYFV/53RrtCyD2HlrtrdNUAtmB7Xts5et6u5/MOaZ/SLick0+
hFvu+c+Z6n/XUjkurJgARH5pO7917tALOxrN5fcPImxHhPalR6D90Bo0fa3SPXez7vTXTf/D6OWS
T1k+kEcQSrCFWMBvf/iu7QhCnh7U3xQuTY+8npTD5+32GPg8SecmqKc22CzeIs2LgtjZeOJVEqM7
h0S2EQvVDFKvaYwPBt/QolOLV5h7z/0HJPT8vcP9SpIClxvyt7bPZYoaorVyGTkwggWsMIIElKAD
AgECAgcbY7rQHiw9MA0GCSqGSIb3DQEBCwUAMIGVMQswCQYDVQQGEwJERTFFMEMGA1UEChM8VmVy
ZWluIHp1ciBGb2VyZGVydW5nIGVpbmVzIERldXRzY2hlbiBGb3JzY2h1bmdzbmV0emVzIGUuIFYu
MRAwDgYDVQQLEwdERk4tUEtJMS0wKwYDVQQDEyRERk4tVmVyZWluIENlcnRpZmljYXRpb24gQXV0
aG9yaXR5IDIwHhcNMTYwNTI0MTEzODQwWhcNMzEwMjIyMjM1OTU5WjCBjTELMAkGA1UEBhMCREUx
RTBDBgNVBAoMPFZlcmVpbiB6dXIgRm9lcmRlcnVuZyBlaW5lcyBEZXV0c2NoZW4gRm9yc2NodW5n
c25ldHplcyBlLiBWLjEQMA4GA1UECwwHREZOLVBLSTElMCMGA1UEAwwcREZOLVZlcmVpbiBHbG9i
YWwgSXNzdWluZyBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJ07eRxH3h+Gy8Zp
1xCeOdfZojDbchwFfylfS2jxrRnWTOFrG7ELf6Gr4HuLi9gtzm6IOhDuV+UefwRRNuu6cG1joL6W
LkDh0YNMZj0cZGnlm6Stcq5oOVGHecwX064vXWNxSzl660Knl5BpBb+Q/6RAcL0D57+eGIgfn5mI
TQ5HjUhfZZkQ0tkqSe3BuS0dnxLLFdM/fx5ULzquk1enfnjK1UriGuXtQX1TX8izKvWKMKztFwUk
P7agCwf9TRqaA1KgNpzeJIdl5Of6x5ZzJBTN0OgbaJ4YWa52fvfRCng8h0uwN89Tyjo4EPPLR22M
ZD08WkVKusqAfLjz56dMTM0CAwEAAaOCAgUwggIBMBIGA1UdEwEB/wQIMAYBAf8CAQEwDgYDVR0P
AQH/BAQDAgEGMCkGA1UdIAQiMCAwDQYLKwYBBAGBrSGCLB4wDwYNKwYBBAGBrSGCLAEBBDAdBgNV
HQ4EFgQUazqYi/nyU4na4K2yMh4JH+iqO3QwHwYDVR0jBBgwFoAUk+PYMiba1fFKpZFK4OpL4qIM
z+EwgY8GA1UdHwSBhzCBhDBAoD6gPIY6aHR0cDovL2NkcDEucGNhLmRmbi5kZS9nbG9iYWwtcm9v
dC1nMi1jYS9wdWIvY3JsL2NhY3JsLmNybDBAoD6gPIY6aHR0cDovL2NkcDIucGNhLmRmbi5kZS9n
bG9iYWwtcm9vdC1nMi1jYS9wdWIvY3JsL2NhY3JsLmNybDCB3QYIKwYBBQUHAQEEgdAwgc0wMwYI
KwYBBQUHMAGGJ2h0dHA6Ly9vY3NwLnBjYS5kZm4uZGUvT0NTUC1TZXJ2ZXIvT0NTUDBKBggrBgEF
BQcwAoY+aHR0cDovL2NkcDEucGNhLmRmbi5kZS9nbG9iYWwtcm9vdC1nMi1jYS9wdWIvY2FjZXJ0
L2NhY2VydC5jcnQwSgYIKwYBBQUHMAKGPmh0dHA6Ly9jZHAyLnBjYS5kZm4uZGUvZ2xvYmFsLXJv
b3QtZzItY2EvcHViL2NhY2VydC9jYWNlcnQuY3J0MA0GCSqGSIb3DQEBCwUAA4IBAQCBeEWkTqR/
DlXwCbFqPnjMaDWpHPOVnj/z+N9rOHeJLI21rT7H8pTNoAauusyosa0zCLYkhmI2THhuUPDVbmCN
T1IxQ5dGdfBi5G5mUcFCMWdQ5UnnOR7Ln8qGSN4IFP8VSytmm6A4nwDO/afr0X9XLchMX9wQEZc+
lgQCXISoKTlslPwQkgZ7nu7YRrQbtQMMONncsKk/cQYLsgMHM8KNSGMlJTx6e1du94oFOO+4oK4v
9NsH1VuEGMGpuEvObJAaguS5Pfp38dIfMwK/U+d2+dwmJUFvL6Yb+qQTkPp8ftkLYF3sv8pBoGH7
EUkp2KgtdRXYShjqFu9VNCIaE40GMIIF4DCCBMigAwIBAgIMIRX9tDE2QqO3mVLXMA0GCSqGSIb3
DQEBCwUAMIGNMQswCQYDVQQGEwJERTFFMEMGA1UECgw8VmVyZWluIHp1ciBGb2VyZGVydW5nIGVp
bmVzIERldXRzY2hlbiBGb3JzY2h1bmdzbmV0emVzIGUuIFYuMRAwDgYDVQQLDAdERk4tUEtJMSUw
IwYDVQQDDBxERk4tVmVyZWluIEdsb2JhbCBJc3N1aW5nIENBMB4XDTE5MDYwNDE0MjkxMFoXDTIy
MDYwMzE0MjkxMFowfDELMAkGA1UEBhMCREUxIDAeBgNVBAoMF0ZhY2hob2Noc2NodWxlIE11ZW5z
dGVyMTIwMAYDVQQLDClGYWNoYmVyZWljaCBFbGVrdHJvdGVjaG5payB1bmQgSW5mb3JtYXRpazEX
MBUGA1UEAwwOTWljaGFlbCBUdWV4ZW4wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDM
r8qQcPxLFCxzPtXvRyM9KeQaxyMA8gwUNc7IIiATs6mRQFe5ib/mvwT9nc0bAa+94go6HJDiD3FJ
NkTo4u8aBsIcTt5pJtdBQLm88PLakbe3+fp/00//n7xxbTh7mAtFVCf25LxDCKkrdGk/+jglRq/R
VdwhZZ3VpYCrx8YfI/hIzdRL3+4I4z/mnQ8K0X8d2MVVPG+9nBEngdnYGez5f/8wIVOgEYYBc21k
yvMnVXLu2Ing+LwBd0gDG9Vasv87MNHCOZfJTNBlLhI2UDei/uNg9Zd4ynlMpPWZ7v0oiDWvmv8E
OuD4oric8heyD0OYK2FL4qcVC4dn4pnyulfHAgMBAAGjggJOMIICSjA+BgNVHSAENzA1MA8GDSsG
AQQBga0hgiwBAQQwEAYOKwYBBAGBrSGCLAEBBAQwEAYOKwYBBAGBrSGCLAIBBAQwCQYDVR0TBAIw
ADAOBgNVHQ8BAf8EBAMCBeAwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMB0GA1UdDgQW
BBTxiodBVL/lA4p5iNesIsJRhhgd6zAfBgNVHSMEGDAWgBRrOpiL+fJTidrgrbIyHgkf6Ko7dDAg
BgNVHREEGTAXgRV0dWV4ZW5AZmgtbXVlbnN0ZXIuZGUwgY0GA1UdHwSBhTCBgjA/oD2gO4Y5aHR0
cDovL2NkcDEucGNhLmRmbi5kZS9kZm4tY2EtZ2xvYmFsLWcyL3B1Yi9jcmwvY2FjcmwuY3JsMD+g
PaA7hjlodHRwOi8vY2RwMi5wY2EuZGZuLmRlL2Rmbi1jYS1nbG9iYWwtZzIvcHViL2NybC9jYWNy
bC5jcmwwgdsGCCsGAQUFBwEBBIHOMIHLMDMGCCsGAQUFBzABhidodHRwOi8vb2NzcC5wY2EuZGZu
LmRlL09DU1AtU2VydmVyL09DU1AwSQYIKwYBBQUHMAKGPWh0dHA6Ly9jZHAxLnBjYS5kZm4uZGUv
ZGZuLWNhLWdsb2JhbC1nMi9wdWIvY2FjZXJ0L2NhY2VydC5jcnQwSQYIKwYBBQUHMAKGPWh0dHA6
Ly9jZHAyLnBjYS5kZm4uZGUvZGZuLWNhLWdsb2JhbC1nMi9wdWIvY2FjZXJ0L2NhY2VydC5jcnQw
DQYJKoZIhvcNAQELBQADggEBABs3VlmIZ1VF3HkaQdjInZYmamRabbdgJ7cz6m6o/agKL7+Vhwx7
1BaaYs2gMa5Nu/GJ3YfdqIsUlYtKdl58Yhp/89E6xBfJkItS+rE8RFdf2XgklGlx7GmsvdA3tId5
b6K6r9a5wpVN0epxY6K8wwpzEib6fJLcHylybQXZ7JSOaLRLp6WU3QPoyTT7FpvAe/0b2MSCbPX4
fc53PCn2aGgXuRFVQeCn1SP1BF3QW1ppkFhcF6G+0JcUxYFAXE6r/71WZBvUHqoG/th2hAwQnS+Y
KhUYh4SZQH3/ursXXJYXQ5vyIhkN1FZlmtWA8+ofdCnoqSTbiSX2Aa/kKbTapwgxggOdMIIDmQIB
ATCBnjCBjTELMAkGA1UEBhMCREUxRTBDBgNVBAoMPFZlcmVpbiB6dXIgRm9lcmRlcnVuZyBlaW5l
cyBEZXV0c2NoZW4gRm9yc2NodW5nc25ldHplcyBlLiBWLjEQMA4GA1UECwwHREZOLVBLSTElMCMG
A1UEAwwcREZOLVZlcmVpbiBHbG9iYWwgSXNzdWluZyBDQQIMIRX9tDE2QqO3mVLXMA0GCWCGSAFl
AwQCAQUAoIIBzzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMDEw
MDUyMDA4MzZaMC8GCSqGSIb3DQEJBDEiBCCIceBkho3fHI8uexQGPANoVZMUXeVfA2R0ps6aLANX
/zCBrwYJKwYBBAGCNxAEMYGhMIGeMIGNMQswCQYDVQQGEwJERTFFMEMGA1UECgw8VmVyZWluIHp1
ciBGb2VyZGVydW5nIGVpbmVzIERldXRzY2hlbiBGb3JzY2h1bmdzbmV0emVzIGUuIFYuMRAwDgYD
VQQLDAdERk4tUEtJMSUwIwYDVQQDDBxERk4tVmVyZWluIEdsb2JhbCBJc3N1aW5nIENBAgwhFf20
MTZCo7eZUtcwgbEGCyqGSIb3DQEJEAILMYGhoIGeMIGNMQswCQYDVQQGEwJERTFFMEMGA1UECgw8
VmVyZWluIHp1ciBGb2VyZGVydW5nIGVpbmVzIERldXRzY2hlbiBGb3JzY2h1bmdzbmV0emVzIGUu
IFYuMRAwDgYDVQQLDAdERk4tUEtJMSUwIwYDVQQDDBxERk4tVmVyZWluIEdsb2JhbCBJc3N1aW5n
IENBAgwhFf20MTZCo7eZUtcwDQYJKoZIhvcNAQEBBQAEggEAyZWuwS/9oFUu5pqW93edPSJaA5dO
DbIYJJ4O3C/fwtSjFkVylhzmZpe1YvTigngMa9OCZ+9Fv3RwHnud6U2Ym3sCsbzhP7YwevzQHMi0
VVhTrYhbQQuQzi8BI/fnLG36FSdgRTJ9OFVDGgl9zVRQlMEvU/hHhGFHsXMOxBZ/7Ir3fWv4x7KY
tDeDyQ5a3nk69G+Do1j+7nEsS0E6SZCInj+IzEZykwQ+XGJS2XJo1NZqiAmChLcOZoPLY1akNGf0
/sxeBzguID45TvWpebrmvO6gv49lI3dshZs4FcOTGgKVQ5S/zPkzznDe5Ug8XLIpgtA8LMZHI+xw
d5LVqcSS0wAAAAAAAA==
--Apple-Mail=_FC7559EC-7516-4B2D-A2E8-F74B41FB61BA--
